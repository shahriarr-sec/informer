#!/usr/bin/env bash
#problem in installing knockpy in kali \\no problem in ubuntu
#problem in installing dnscan \\Please manually install it

# Colors
NC='\033[0m';
RED='\033[0;31m';
GREEN='\033[0;32m';
BLUE='\033[0;34m';
ORANGE='\033[0;33m';

UBUNTU=;
DEBIAN=;
KALI=;
TOOLS="$HOME/tools";

function install_kali() {
		echo -e "$GREEN""[+] Installing for Kali.""$NC";
		sudo apt-get update;
	 	sudo apt-get install git wget curl nmap masscan chromium openssl libnet-ssleay-perl p7zip-full build-essential python-pip python3-pip unzip -y;
		sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl -y;
		curl https://pyenv.run | bash;
		exec $SHELL;
		pyenv;
		pyenv install 2.7.18;
		pyenv global 2.7.18;
		sudo apt-get update;
		install_pip;
		install_dnscan;
	        install_massdns;
		install_sublist3r;
		install_corstest;
		install_flumberbuckets;
		install_amass;
		install_knockpy;
		install_LinkFinder;
		install_go;
		install_go_tools;
		install_feroxbuster;
}
function install_parrot() {
		echo -e "$GREEN""[+] Installing for Parrot.""$NC";
		sudo apt-get update;
	 	sudo apt-get install git wget curl nmap masscan chromium openssl libnet-ssleay-perl p7zip-full build-essential python-pip python3-pip unzip -y;
		install_pip;
		install_dnscan;
	        install_massdns;
		install_sublist3r;
		install_corstest;
		install_flumberbuckets;
		install_amass;
		install_knockpy;
		install_LinkFinder;
		install_go;
		install_go_tools;
		install_feroxbuster;
}
function install_debian() {
		echo -e "$GREEN""[+] Installing for Debian.""$NC";
		sudo apt-get update;
	 	sudo apt-get install git wget curl nmap masscan chromium openssl libnet-ssleay-perl p7zip-full build-essential python-pip python3-pip unzip -y;
		install_pip;
		install_dnscan;
	        install_massdns;
		install_sublist3r;
		install_corstest;
		install_flumberbuckets;
		install_amass;
		install_knockpy;
		install_LinkFinder;
		install_go;
		install_go_tools;
		install_feroxbuster;
}
function install_ubuntu() {
		echo -e "$GREEN""[+] Installing for Ubuntu.""$NC";
		sudo apt-get update;
	 	sudo apt-get install git wget curl nmap masscan chromium-browser openssl libnet-ssleay-perl p7zip-full build-essential python-pip python3-pip knockpy unzip -y;
		sudo snap install chromium
		install_pip;
		install_dnscan;
	        install_massdns;
		install_sublist3r;
		install_corstest;
		install_flumberbuckets;
		install_amass;
		install_knockpy;
		install_LinkFinder;
		install_go;
		install_go_tools;
		install_feroxbuster;
}

function install_pip() {
		# Run both pip installs
		echo -e "$GREEN""[+] Installing requirements for Python 2 and Python 3.""$NC";
		sudo pip2 install -q -r requirements2.txt;
		sudo pip3 install -q -r requirements3.txt;
}

function install_dnscan() {
		if [[ -d "$TOOLS"/dnscan ]]; then
				echo -e "$GREEN""[+] Updating dnscan.""$NC";
				cd "$TOOLS"/dnscan;
				git pull;
				cd -;
		else
		echo -e "$GREEN""[+] Installing dnscan from Github.""$NC";
		git clone https://github.com/rbsec/dnscan.git "$TOOLS"/dnscan;
		fi
}

function install_LinkFinder() {
		if [[ -d "$TOOLS"/LinkFinder ]]; then
				echo -e "$GREEN""[+] Updating LinkFinder.""$NC";
				cd "$TOOLS"/bfac;
				git pull;
				cd -;
		else
		echo -e "$GREEN""[+] Installing LinkFinder from Github.""$NC";
		git clone https://github.com/GerbenJavado/LinkFinder.git "$TOOLS"/LinkFinder;
		fi
}

function install_massdns() {
		if [[ -d "$TOOLS"/massdns ]]; then
				echo -e "$GREEN""[+] Updating massdns.""$NC";
				cd "$TOOLS"/massdns;
				git pull;
				cd -;
		else
		echo -e "$GREEN""[+] Installing massdns from Github.""$NC";
		git clone https://github.com/blechschmidt/massdns.git "$TOOLS"/massdns;
		fi
		
		# Compile massdns
		echo -e "$GREEN""[+] Compiling massdns from source.""$NC";
		cd "$TOOLS"/massdns;
		make;
		cd -;
}

function install_sublist3r() {
		if [[ -d "$TOOLS"/Sublist3r ]]; then
				echo -e "$GREEN""[+] Updating sublist3r.""$NC";
				cd "$TOOLS"/Sublist3r;
				git pull;
				cd -;
		else
		echo -e "$GREEN""[+] Installing sublist3r from Github.""$NC";
		git clone https://github.com/aboul3la/Sublist3r.git "$TOOLS"/Sublist3r;
		fi
}


function install_corstest() {
		if [[ -d "$TOOLS"/CORStest ]]; then
				echo -e "$GREEN""[+] Updating CORStest.""$NC";
				cd "$TOOLS"/CORStest;
				git pull;
				cd -;
		else
		echo -e "$GREEN""[+] Installing CORStest from Github.""$NC";
		git clone https://github.com/RUB-NDS/CORStest.git "$TOOLS"/CORStest;
		fi
}

function install_flumberbuckets() {
		if [[ -d "$TOOLS"/flumberbuckets ]]; then
				echo -e "$GREEN""[+] Updating flumberbuckets.""$NC";
				cd "$TOOLS"/flumberboozle/flumberbuckets;
				git pull;
				cd -;
		else
		echo -e "$GREEN""[+] Installing flumberbuckets from Github.""$NC";
		git clone https://github.com/fellchase/flumberboozle.git "$TOOLS"/flumberboozle;
		fi
}

function install_knockpy() {
		if [[ -d "$TOOLS"/knock ]]; then
				echo -e "$GREEN""[+] Updating Knockpy.""$NC";
				cd "$TOOLS"/knock;
				git pull;
				cd -;
		else
		echo -e "$GREEN""[+] Installing Knockpy from Github.""$NC";
		git clone https://github.com/SolomonSklash/knock.git "$TOOLS"/knock;
		cd "$TOOLS"/knock;
		sudo python setup.py install;
		cd -;
		fi
}

function install_go_tools() {
		source $HOME/.profile;
		echo -e "$GREEN""[+] Installing Go tools from Github.""$NC";
		sleep 1;
		echo -e "$GREEN""[+] Installing subfinder from Github.""$NC";
		GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder;
		echo -e "$GREEN""[+] Installing subjack from Github.""$NC";
		go get -u github.com/haccer/subjack;
		echo -e "$GREEN""[+] Installing ffuf from Github.""$NC";
		go get -u github.com/ffuf/ffuf;
                echo -e "$GREEN""[+] Installing meg from Github.""$NC";
		go get -u github.com/tomnomnom/meg
		#echo -e "$GREEN""[+] Installing gobuster from Github.""$NC";
		#go get -u github.com/OJ/gobuster;
		# echo -e "$GREEN""[+] Installing inception from Github.""$NC";
		# go get -u github.com/proabiral/inception;
		echo -e "$GREEN""[+] Installing waybackurls from Github.""$NC";
		go get -u github.com/tomnomnom/waybackurls;
		echo -e "$GREEN""[+] Installing qsreplace from Github.""$NC";
		go get -u github.com/tomnomnom/qsreplace
                echo -e "$GREEN""[+] Installing kxss from Github.""$NC";
		go get -u github.com/tomnomnom/hacks/kxss
		echo -e "$GREEN""[+] Installing gowitness from Github.""$NC";
		go get -u github.com/sensepost/gowitness
		echo -e "$GREEN""[+] Installing rescope from Github.""$NC";
                go get -u github.com/root4loot/rescope;
		echo -e "$GREEN""[+] Installing httprobe from Github.""$NC";
		go get -u github.com/tomnomnom/httprobe;
                echo -e "$GREEN""[+] Installing anew from Github.""$NC";
		go get -u github.com/tomnomnom/anew
		echo -e "$GREEN""[+] Installing burl from Github.""$NC";
		go get github.com/tomnomnom/burl
                echo -e "$GREEN""[+] Installing filter-resolved from Github.""$NC";
		go get github.com/tomnomnom/hacks/filter-resolved
		echo -e "$GREEN""[+] Installing assetfinder from Github.""$NC";
		go get -u github.com/tomnomnom/assetfinder
		echo -e "$GREEN""[+] Installing unfurl from Github.""$NC";
		go get -u github.com/tomnomnom/unfurl
		echo -e "$GREEN""[+] Installing nuclei from Github.""$NC";
		GO111MODULE=on go get -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei
		echo -e "$GREEN""[+] Updating nuclei-templates from Github.""$NC";
                nuclei -update-templates
                echo -e "$GREEN""[+] Installing httpx from Github.""$NC";
                GO111MODULE=on go get -v github.com/projectdiscovery/httpx/cmd/httpx
                echo -e "$GREEN""[+] Installing b64 (to find and decode b64) from Github.""$NC";
                go get -u github.com/tomnomnom/hacks/b64d
                echo -e "$GREEN""[+] Installing comb (to combine words) from Github.""$NC";
                go get -u github.com/tomnomnom/hacks/comb
                echo -e "$GREEN""[+] Installing ettu (a brute forcer with tko) from Github.""$NC";
                go get -u github.com/tomnomnom/hacks/ettu
                echo -e "$GREEN""[+] Installing tok (a word breaker) from Github.""$NC";
                go get -u github.com/tomnomnom/hacks/tok
                echo -e "$GREEN""[+] Installing get-title from Github.""$NC";
                go get -u github.com/tomnomnom/hacks/get-title
                echo -e "$GREEN""[+] Installing html-comments from Github.""$NC";
                go get -u github.com/tomnomnom/hacks/html-comments
                echo -e "$GREEN""[+] Installing urinteresting from Github.""$NC";
                go get -u github.com/tomnomnom/hacks/urinteresting
	        echo -e "$GREEN""[+] Install amass from Github.""$NC";
	        go get -v github.com/OWASP/Amass/cmd/amass
}

function install_go() {
		if [[ -e /usr/local/go/bin/go ]]; then
				echo -e "$GREEN""[i] Go is already installed, skipping installation.""$NC";
				return;
		fi
		echo -e "$GREEN""[+] Installing Go 1.15.7 from golang.org.""$NC";
		wget -nv https://dl.google.com/go/go1.15.7.linux-amd64.tar.gz;
		sudo tar -C /usr/local -xzf go1.15.7.linux-amd64.tar.gz;
		echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin:" >> "$HOME"/.profile;
		echo "export GOPATH=$HOME/go" >> "$HOME"/.profile;
		source "$HOME"/.profile;
		rm -rf go1.15.7.linux-amd64.tar.gz;
}

function install_amass() {
		if [[ -d "$TOOLS"/amass ]]; then
				rm -rf "$TOOLS"/amass;
		fi
		echo -e "$GREEN""[+] Installing amass 3.11.2 from Github.""$NC";
		wget -nv https://github.com/OWASP/Amass/releases/download/v3.11.2/amass_linux_amd64.zip -O "$TOOLS"/amass.zip;
		unzip -j "$TOOLS"/amass.zip -d "$TOOLS"/amass;
		rm "$TOOLS"/amass.zip;
}

function install_feroxbuster(){
	    if [[ -d "$TOOLS"/feroxbuster ]]; then
				rm -rf "$TOOLS"/feroxbuster;
		fi
		echo -e "$GREEN""[+] Installing feroxbuster from Github.""$NC";
		curl -sL https://raw.githubusercontent.com/epi052/feroxbuster/master/install-nix.sh | bash
		echo "Installed github you can manage this by making an ferox buster directory"


}

# Check for custom path
CUSTOM_PATH=$1;
if [[ "$CUSTOM_PATH" != "" ]]; then
		if [[ -e "$1" ]]; then
				TOOLS="$CUSTOM_PATH";
		else
				echo -e "$RED""The path provided does not exist or can't be opened""$NC";
				exit 1;
		fi
fi

# Create install directory
mkdir -pv "$HOME"/tools;

grep 'Ubuntu' /etc/issue 1>/dev/null;
UBUNTU="$?";
grep 'Debian' /etc/issue 1>/dev/null;
DEBIAN="$?";
grep 'Kali' /etc/issue 1>/dev/null;
KALI="$?";
grep 'Parrot' /etc/issue 1>/dev/null;
PARROT="$?";
if [[ "$UBUNTU" == 0 ]]; then 
		install_ubuntu;
elif [[ "$DEBIAN" == 0 ]]; then
		install_debian;
elif [[ "$KALI" == 0 ]]; then
		install_kali;
elif [[ "$PARROT" == 0 ]]; then
		install_parrot;
else
		echo -e "$RED""Unsupported distro detected. Exiting...""$NC";
		exit 1;
fi

echo "Installing Emissary from github..."
cd ~/tools;git clone https://github.com/BountyStrike/Emissary.git;cd Emissary;go build;mv emissary /usr/local/bin;cd;
echo "Installing Arjun from Github ..."
cd ~/tools; git clone https://github.com/s0md3v/Arjun.git;cd;
echo "Installing Subdomainizer"
cd ~/tools;git clone https://github.com/nsonaniya2010/SubDomainizer.git;cd SubDomainizer;pip3 install -r requirements.txt;cd;
echo "Installing blc from github with npm"
sudo apt-get install npm -y;npm install broken-link-checker -g
echo "Installing findomain..."
cd ~/tools;mkdir findomain;cd findomain;wget https://github.com/Findomain/Findomain/releases/download/3.0.1/findomain-linux;chmod +x findomain-linux;cd;
echo "If your knockpy installation shows error visit:https://www.kali.org/docs/general-use/using-eol-python-versions/ to setup python2"


echo -e "$BLUE""[i] Please run 'source ~/.profile' to add the Go binary path to your \$PATH variable, then run Informer.""$NC";
echo -e "$ORANGE""[i] Note: In order to use flumberbuckets, you must configure your personal AWS credentials in the aws CLI tool.""$NC";
echo -e "$ORANGE""[i] See https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html for details.""$NC";
