function coloredEcho(){
    local exp=$1;
    local color=$2;
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white|*) color=7 ;; # white or invalid color
       esac
    fi
    tput setaf $color;
    echo $exp;
    tput sgr0;
}

function Test_Package_Installed() {
	dpkg_output=$(dpkg -s $1 2>/dev/null | grep "Status" | grep -o "installed" -c)
	echo "$dpkg_output"
}


function Test_And_Install_Package() {
	if [[ $(Test_Package_Installed $1) == 0 ]]; then
	    echo "Install $1"
	    sudo apt-get install $1 -y -qq
    fi

	if [[ $(Test_Package_Installed $1) == 1 ]]; then
		coloredEcho "$1 installed." green
	else
		coloredEcho "$1 installation failed." red
		exit 1;
	fi
}


Test_And_Install_Package curl
Test_And_Install_Package git
Test_And_Install_Package cmake
Test_And_Install_Package vim
Test_And_Install_Package python-pip
Test_And_Install_Package guake

read -p "Would you like to install Visual Studio Code? 'Y' or 'N' :" answer
case answer in
Y|y) 
mkdir /tmp/vscode
cd /tmp/vscode/
wget https://vscode.cdn.azure.cn/stable/950b8b0d37a9b7061b6f0d291837ccc4015f5ecd/code_1.22.1-1522974421_amd64.deb
sudo dpkg -i *.deb
cd ~;;
N|n)
echo "You will not install Visual Studio Code";;
