#!/bin/bash
echo "Use:./informer.sh domains.lst"
cat << "EOF"
  _____ _   _ ______ ____  _____  __  __ ______ _____
 |_   _| \ | |  ____/ __ \|  __ \|  \/  |  ____|  __ \
   | | |  \| | |__ | |  | | |__) | \  / | |__  | |__) |
   | | | . ` |  __|| |  | |  _  /| |\/| |  __| |  _  /
  _| |_| |\  | |   | |__| | | \ \| |  | | |____| | \ \
 |_____|_| \_|_|    \____/|_|  \_\_|  |_|______|_|  \_\
EOF
#You may want to customize flumberbuckets
#This script does not check for js files,maybe I will add linkfinder later
#Subdomainizer gives so much false positive you should always meg with gf patterns manually
#This script does not do content discovery,You may want to do that with feroxbuster.
#Recomended to use in vps
#Check api with AdvancedKeyHacks
host=$1
#Change the word list path to use your own wordlist.Word lists must end with wordlist.txt. e.g /path/wordlist.txt
wordlist_dns="/root/tools/informer/wordlists/dns/wordlist.txt"
resolvers="/root/tools/informer/resolvers.txt"
#Change to your desired wordlists path for directory search
wordlist_cd="/root/tools/informer/wordlists/ContentDiscovery/wordlists.txt"

subdomain_enum(){
for sub in $(cat $host);
do
mkdir -p /root/.gdrive/Recon-Data/$sub /root/.gdrive/Recon-Data/$sub/Subdomains /root/.gdrive/Recon-Data/$sub/ReconData /root/.gdrive/Recon-Data/$sub/ReconData/subjack /root/.gdrive/Recon-Data/$sub/ReconData/paramlist /root/.gdrive/Recon-Data/$sub/ReconData/nuclei /root/.gdrive/Recon-Data/$sub/ReconData/CustomWordlist /root/.gdrive/Recon-Data/$sub/Screenshots /root/.gdrive/Recon-Data/$sub/Meg /root/.gdrive/Recon-Data/$sub/gf /root/.gdrive/Recon-Data/$sub/ContentDiscovery
#dnscan
echo "Listing Subdomains using dnscan..."
python3 /root/tools/dnscan/dnscan.py -d $sub -t 100 -o /root/.gdrive/Recon-Data/$sub/Subdomains/dnscan_out.txt -w $wordlist_dns;
# Remove headers and leading spaces
sed '1,/A records/d' /root/.gdrive/Recon-Data/$sub/Subdomains/dnscan_out.txt | tr -d ' ' > /root/.gdrive/Recon-Data/$sub/Subdomains/trimmed;
cut /root/.gdrive/Recon-Data/$sub/Subdomains/trimmed -d '-' -f 2 > /root/.gdrive/Recon-Data/$sub/Subdomains/dnscan-domains.txt;
rm /root/.gdrive/Recon-Data/$sub/Subdomains/trimmed;
# Cat output into all_subdomain
cat /root/.gdrive/Recon-Data/$sub/Subdomains/dnscan-domains.txt >> /root/.gdrive/Recon-Data/$sub/Subdomains/all_subdomain;
# Check if Ctrl+C was pressed and added to domain
grep -v 'KeyboardInterrupt' /root/.gdrive/Recon-Data/$sub/Subdomains/all_subdomain > /root/.gdrive/Recon-Data/$sub/Subdomains/tmp;
mv /root/.gdrive/Recon-Data/$sub/Subdomains/tmp /root/.gdrive/Recon-Data/$sub/Subdomains/all_subdomain;
rm /root/.gdrive/Recon-Data/$sub/Subdomains/dnscan-domains.txt;
rm /root/.gdrive/Recon-Data/$sub/Subdomains/dnscan_out.txt


#subfinder
echo "Listing Subdomains using subfinder..."
subfinder -d $sub -o /root/.gdrive/Recon-Data/$sub/Subdomains/subfinder.txt;
#Cat output into all_subdomain
cat /root/.gdrive/Recon-Data/$sub/Subdomains/subfinder.txt >> /root/.gdrive/Recon-Data/$sub/Subdomains/all_subdomain;
rm /root/.gdrive/Recon-Data/$sub/Subdomains/subfinder.txt
#amass
echo "Listing Subdomains using amass..."
amass enum -d $sub -brute -ipv4 -rf $resolvers -active -w $wordlist_dns -o /root/.gdrive/Recon-Data/$sub/Subdomains/amass-output.txt -min-for-recursive 3;
# Cat output into all_subdomain
cut -d ' ' -f 1 /root/.gdrive/Recon-Data/$sub/Subdomains/amass-output.txt >> /root/.gdrive/Recon-Data/$sub/Subdomains/all_subdomain;
rm /root/.gdrive/Recon-Data/$sub/Subdomains/amass-output.txt;
#sublist3r
echo "Listing Subdomains using sublist3r..."
python3 /root/tools/Sublist3r/sublist3r.py -d $sub -v -t 100 -o /root/.gdrive/Recon-Data/$sub/Subdomains/sublist3r-output.txt;
# Cat output into all_subdomain
cat /root/.gdrive/Recon-Data/$sub/Subdomains/sublist3r-output.txt >> /root/.gdrive/Recon-Data/$sub/Subdomains/all_subdomain;
rm /root/.gdrive/Recon-Data/$sub/Subdomains/sublist3r-output.txt;
#assetfinder
echo "Listing Subdomains using assetfinder..."
assetfinder -subs-only $sub | tee /root/.gdrive/Recon-Data/$sub/Subdomains/assetfinder.txt;
# Cat output into all_subdomain
cat /root/.gdrive/Recon-Data/$sub/Subdomains/assetfinder.txt >> /root/.gdrive/Recon-Data/$sub/Subdomains/all_subdomain;
rm /root/.gdrive/Recon-Data/$sub/Subdomains/assetfinder.txt
#knokpy,forked
echo "Listing Subdomains using knockpy..."
knockpy $sub -w $wordlist_dns -o /root/.gdrive/Recon-Data/$sub/Subdomains/knock-output.txt;
# Parse output and add to all domain and IP lists
awk -F ',' '{print $2" "$3}' /root/.gdrive/Recon-Data/$sub/Subdomains/knock-output.txt | grep -e "$DOMAIN$" > /root/.gdrive/Recon-Data/$sub/Subdomains/knock-tmp.txt;
cut -d ' ' -f 2 /root/.gdrive/Recon-Data/$sub/Subdomains/knock-tmp.txt >> /root/.gdrive/Recon-Data/$sub/Subdomains/all_subdomain;
rm /root/.gdrive/Recon-Data/$sub/Subdomains/knock-tmp.txt;
rm /root/.gdrive/Recon-Data/$sub/Subdomains/knock-output.txt;
# Get unique domains, ignoring case
sort /root/.gdrive/Recon-Data/$sub/Subdomains/all_subdomain | uniq -i > /root/.gdrive/Recon-Data/$sub/Subdomains/temp2;
mv /root/.gdrive/Recon-Data/$sub/Subdomains/temp2 /root/.gdrive/Recon-Data/$sub/Subdomains/all_subdomain;

#findomain and discord notification
#Please chage iwas modified during adding function
echo "Listing Subdomains using findomain..."
~/tools/findomain/findomain-linux --import-subdomains /root/.gdrive/Recon-Data/$sub/Subdomains/all_subdomain -m -t $sub --aempty -c /root/.config/findomain/config.toml -u /root/.gdrive/Recon-Data/$sub/Subdomains/findomain.txt;
#Cat output into all_subdomain
cat /root/.gdrive/Recon-Data/$sub/Subdomains/findomain.txt >> /root/.gdrive/Recon-Data/$sub/Subdomains/all_subdomain;
rm /root/.gdrive/Recon-Data/$sub/Subdomains/findomain.txt;
# Get unique domains, ignoring case
sort /root/.gdrive/Recon-Data/$sub/Subdomains/all_subdomain | uniq -i > /root/.gdrive/Recon-Data/$sub/Subdomains/temp3;
mv /root/.gdrive/Recon-Data/$sub/Subdomains/temp3 /root/.gdrive/Recon-Data/$sub/Subdomains/all_subdomain;
done
}
subdomain_enum

resolve_subdomains(){
for sub in $(cat $host);
do
echo "Resolving subdomains for $sub using filter-resolved  ..."	
cat /root/.gdrive/Recon-Data/$sub/Subdomains/all_subdomain | filter-resolved > /root/.gdrive/Recon-Data/$sub/Subdomains/resolved_subdomains.txt
#rm -r /root/.gdrive/Recon-Data/$sub/Subdomains/all_subdomain
done
}
resolve_subdomains

subtko(){
for sub in $(cat $host);
do
echo "Checking subdomain take over for $sub,cross your finger..."
#https
subjack -w /root/.gdrive/Recon-Data/$sub/Subdomains/resolved_subdomains.txt -a -m -t 100 -timeout 30 -ssl -v 3 | grep -iv "Not Vulnerable" > /root/.gdrive/Recon-Data/$sub/ReconData/subjack/https_subjack.txt;
cat /root/.gdrive/Recon-Data/$sub/ReconData/subjack/https_subjack.txt > /root/.gdrive/Recon-Data/$sub/ReconData/subjack/subdomain_takeover.txt;
#http
subjack -w /root/.gdrive/Recon-Data/$sub/Subdomains/resolved_subdomains.txt -a -m -t 100 -timeout 30 -v 3 | grep -iv "Not Vulnerable" > /root/.gdrive/Recon-Data/$sub/ReconData/subjack/http_subjack.txt;
cat /root/.gdrive/Recon-Data/$sub/ReconData/subjack/http_subjack.txt >> /root/.gdrive/Recon-Data/$sub/ReconData/subjack/subdomain_takeover.txt
# Get unique results,ignoring case
sort /root/.gdrive/Recon-Data/$sub/ReconData/subjack/subdomain_takeover.txt | uniq -i > /root/.gdrive/Recon-Data/$sub/ReconData/subjack/temp4;
mv /root/.gdrive/Recon-Data/$sub/ReconData/subjack/temp4 /root/.gdrive/Recon-Data/$sub/ReconData/subjack/subdomain_takeover.txt;
rm /root/.gdrive/Recon-Data/$sub/ReconData/subjack/https_subjack.txt
rm /root/.gdrive/Recon-Data/$sub/ReconData/subjack/http_subjack.txt 
done
}
subtko

http_prob(){
for sub in $(cat $host);
do
echo "Probing $sub subdomains for http/s ..."
cat /root/.gdrive/Recon-Data/$sub/Subdomains/resolved_subdomains.txt | httpx -threads 200 -o /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt
done
}
http_prob

wayback_data(){
for sub in $(cat $host);
do
echo "Scraping wayback data for $sub ..."
cat /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt | waybackurls | egrep -iv ".(jpg|jpeg|gif|css|tiff|png|tif|png|ttf|woff|woff2|ico|svg)" | sed 's/:80//g;s/:443//g' | sort -u > /root/.gdrive/Recon-Data/$sub/ReconData/waybackurls.txt
done
}
wayback_data

valid_waybackdata(){
for sub in $(cat $host);
do
echo "Validating wayback data for $sub ..."
ffuf -c -u "FUZZ" -w /root/.gdrive/Recon-Data/$sub/ReconData/waybackurls.txt -mc 200 -of csv -o /root/.gdrive/Recon-Data/$sub/ReconData/tmp3.txt;
cat /root/.gdrive/Recon-Data/$sub/ReconData/tmp3.txt | grep http | awk -F "," '{print $1}' >> /root/.gdrive/Recon-Data/$sub/ReconData/valid_wayback.txt
rm /root/.gdrive/Recon-Data/$sub/ReconData/tmp3.txt;
done
}
valid_waybackdata

run_CORStest(){
for sub in $(cat $host);
do
echo "Running CORStest for $sub ..."
python3 ~/tools/CORStest/corstest.py -p 64 /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt > /root/.gdrive/Recon-Data/$sub/ReconData/CORStest_output.txt;
done
}
run_CORStest

aws_scanner(){
for sub in $(cat $host);
do
echo "Searching for a broken bucket in aws using flumberbuckets ... "
python3 ~/tools/flumberboozle/flumberbuckets/flumberbuckets.py -m ~/tools/massdns/bin/massdns -w /root/tools/flumberboozle/flumberbuckets/medium.txt -d /root/.gdrive/Recon-Data/$sub/Subdomains/resolved_subdomains.txt --resolve $resolvers -i test -o /root/.gdrive/Recon-Data/$sub/ReconData/aws_bucket.txt;
done
}
aws_scanner

param_gather(){
for sub in $(cat $host);
do	
echo "Gathering parameters with unfurl..."
cat /root/.gdrive/Recon-Data/$sub/ReconData/waybackurls.txt | grep "?" | unfurl keys > /root/.gdrive/Recon-Data/$sub/ReconData/paramlist/gathered_paramlist.txt
echo "Gather parameters with Arjun..."
python3 ~/tools/Arjun/arjun.py -i /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt -m POST -o /root/.gdrive/Recon-Data/$sub/ReconData/paramlist/arjun_post_result.json 
python3 ~/tools/Arjun/arjun.py -i /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt -m GET -o /root/.gdrive/Recon-Data/$sub/ReconData/paramlist/arjun_get_result.json
done
}
param_gather

scanner(){
for sub in $(cat $host);
do	
echo "Iniatiating nuclei scanner for $sub ..."
echo "Running token templates for $sub ..."
nuclei -l /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt -t /root/nuclei-templates/tokens/ -silent -c 50 | tee /root/.gdrive/Recon-Data/$sub/ReconData/nuclei/nuclei-token.txt
echo "Running subtko templates for $sub .."
nuclei -l /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt -t /root/nuclei-templates/subdomain-takeover/ -silent -c 50 | tee /root/.gdrive/Recon-Data/$sub/ReconData/nuclei/nuclei-stko.txt
echo "Running files templates for $sub ..."
nuclei -l /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt -t /root/nuclei-templates/files/ -silent -c 50 | tee /root/.gdrive/Recon-Data/$sub/ReconData/nuclei/nuclei-files.txt
echo "Running cve templates for $sub ..."
nuclei -l /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt -t /root/nuclei-templates/cves/ -silent -c 50 | tee /root/.gdrive/Recon-Data/$sub/ReconData/nuclei/nuclei-cves.txt
echo "Running vulns templates for $sub ..."
nuclei -l /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt -t /root/nuclei-templates/vulnerabilities/ -silent -c 50 | tee /root/.gdrive/Recon-Data/$sub/ReconData/nuclei/nuclei-vulns.txt
echo "Running generic detection for $sub"
nuclei -l /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt -t /root/nuclei-templates/generic-detections/ -silent -c 50 | tee /root/.gdrive/Recon-Data/$sub/ReconData/nuclei/nuclei-genericdetec.txt
echo "Checking security misfiguration for $sub ..."
nuclei -l /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt -t /root/nuclei-templates/security-misconfiguration/ -silent -c 20 | tee /root/.gdrive/Recon-Data/$sub/ReconData/nuclei/nuclei-misconfig.txt
echo "Running tech templates for $sub ..."
nuclei -l /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt -t /root/nuclei-templates/technologies/ -silent -c 50 | tee /root/.gdrive/Recon-Data/$sub/ReconData/nuclei/nuclei-tech.txt
echo "Running panel templates for $sub ..."
nuclei -l /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt -t /root/nuclei-templates/panels/ -silent -c 50 | tee /root/.gdrive/Recon-Data/$sub/ReconData/nuclei/nuclei-panels.txt
done
}
scanner


CustomWordlist(){
for sub in $(cat $host);
do
echo "Creating new custom wordlist for $sub ..."
cat /root/.gdrive/Recon-Data/$sub/ReconData/waybackurls.txt | unfurl --unique paths | tee /root/.gdrive/Recon-Data/$sub/ReconData/CustomWordlist/paths.txt
cat /root/.gdrive/Recon-Data/$sub/ReconData/waybackurls.txt | unfurl --unique keys | tee /root/.gdrive/Recon-Data/$sub/ReconData/CustomWordlist/params.txt
cat /root/.gdrive/Recon-Data/$sub/ReconData/waybackurls.txt | unfurl --unique values | tee /root/.gdrive/Recon-Data/$sub/ReconData/CustomWordlist/values.txt
cat /root/.gdrive/Recon-Data/$sub/ReconData/waybackurls.txt | unfurl --unique keypairs | tee /root/.gdrive/Recon-Data/$sub/ReconData/CustomWordlist/keypairs.txt
done
}
CustomWordlist

screenshots(){
for sub in $(cat $host);
do
echo "Taking screenshots of $sub with gowitness"
gowitness file -f /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt -X 1280 -Y 720 -D ~/.gdrive/.Database/gowitness.sqlite3 --threads 100 -P /root/.gdrive/Recon-Data/$sub/Screenshots
done
}
screenshots
echo "gowitness report serve 104.161.21.104:2626 to see reports from vps"

broken_link_scanner(){
for sub in $(cat $host);
do
echo "Checking for broken link with blc in $sub and its subdomains "
blc -rfoi --exclude youtube.com --filter-level 3 /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt | grep "BROKEN" > /root/.gdrive/Recon-Data/$sub/ReconData/blc_output.txt
done
}
broken_link_scanner

tom(){
for sub in $(cat $host);
do
echo "Running meg on $sub..."
meg /root/.gdrive/Recon-Data/$sub/ReconData/CustomWordlist/paths.txt /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt  /root/.gdrive/Recon-Data/$sub/Meg -v
done
}
tom

keyfinding(){
for sub in $(cat $host);
do
echo "Scraping for keys from $sub with Subdomainizer"
echo "Subdomainizer gives many false positive it's always a good idea to check them with meg and gf patterns manually"
python3 ~/tools/SubDomainizer/SubDomainizer.py -l /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt -o /root/.gdrive/Recon-Data/$sub/ReconData/Subdomainizer.txt -gt f64827dd745bc1fef554585ff64cb40d90924d38 -g -k -san all 
done
}
keyfinding

gf_pattern(){
for sub in $(cat $host);
do
echo "Only gf that who makes your life easier..."
gf xss /root/.gdrive/Recon-Data/$sub/ReconData/waybackurls.txt | tee /root/.gdrive/Recon-Data/$sub/ReconData/gf/xss.txt
gf sqli /root/.gdrive/Recon-Data/$sub/ReconData/waybackurls.txt | tee /root/.gdrive/Recon-Data/$sub/ReconData/gf/sqli.txt
gf redirect /root/.gdrive/Recon-Data/$sub/ReconData/waybackurls.txt | tee /root/.gdrive/Recon-Data/$sub/ReconData/gf/redirects.txt
#secrets
gf aws-keys /root/.gdrive/Recon-Data/$sub/Meg | tee /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf aws-keys_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf facebook-oauth_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf facebook-token_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf firebase_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf firebase /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf github_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf google-keys_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf google-oauth_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf google-service-account_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf google-token_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf heroku-keys_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf mailchimp-keys_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf mailchimp-keys_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf mailgun-keys_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf paypal-token_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf picatic-keys_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf slack-token_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf slack-webhook_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf twilio-keys_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf twitter-oauth_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
gf twitter-token_secrets /root/.gdrive/Recon-Data/$sub/Meg >> /root/.gdrive/Recon-Data/$sub/ReconData/gf/secrets.txt
#Interesting
gf interestingparams /root/.gdrive/Recon-Data/$sub/ReconData/paramlist/gathered_paramlist.txt | tee /root/.gdrive/Recon-Data/$sub/ReconData/gf/interestingparams.txt
gf interestingsubs /root/.gdrive/Recon-Data/$sub/Subdomains/resolved_subdomains.txt | tee /root/.gdrive/Recon-Data/$sub/ReconData/gf/interestingsubs.txt
done
}
gf_pattern

content_discovery(){
for sub in $(cat $host);
do
cat /root/.gdrive/Recon-Data/$sub/ReconData/httpx.txt | feroxbuster --stdin -e -k -r -d 3 -t 10 -L 1 -w $wordlist_cd -a "Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36" -o /root/.gdrive/Recon-Data/$sub/ContentDiscovery
done
}
content_discovery

echo "Recon is completed,don't forget to check outputs..."
echo "Do not forget to validate your secrets with AdvancedKeyHacks by udit-thakkur..."
emissary -t -m "Informer completed recon for you,Don't forget to check resuls,You may find some juicy stuffs"
