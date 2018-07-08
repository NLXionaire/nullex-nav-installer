#!/bin/bash
#
# Version: v0.9.5
# Date:    July 7, 2018
#
# Run this script with the desired parameters or leave blank to install using defaults. Use -h for help.
#
# Tested to be working on Ubuntu 16.04 x64 with Vultr VPS
# Please report other working instances to @NLXionaire on https://t.me/NullexOfficial
# A special thank you to @marsmensch for releasing the NODEMASTER script which helped immensely for integrating IPv6 support

# Constant Variables
readonly SCRIPT_VERSION="0.9.5"
readonly WALLET_VERSION="1.3.3"
readonly WALLET_FILE="nullex-1.3.3-linux.tar.gz"
readonly WALLET_URL="https://dl.dropboxusercontent.com/s/kec8sgltlo01vu9/"
readonly ARCHIVE_DIR=""
readonly DATA_DIR="NulleX"
readonly WALLET_NAME="nullex"
readonly BLOCKCOUNT_URL=""
readonly REQUIRE_GENERATE_CONF=0
readonly NONE="\033[00m"
readonly ORANGE="\033[00;33m"
readonly RED="\033[01;31m"
readonly GREEN="\033[01;32m"
readonly CYAN="\033[01;36m"
readonly GREY="\033[01;30m"
readonly ULINE="\033[4m"
readonly RC_LOCAL="/etc/rc.local"
readonly NETWORK_BASE_TAG="5123"
readonly CURRENT_USER="$({ who am i | awk '{print $1}'; })"
readonly HOME_DIR="/usr/local/bin"
readonly VERSION_URL="https://raw.githubusercontent.com/NLXionaire/nullex-nav-installer/master/VERSION"
readonly SCRIPT_URL="https://raw.githubusercontent.com/NLXionaire/nullex-nav-installer/master/nullex-nav-installer.sh"
readonly NEW_CHANGES_URL="https://raw.githubusercontent.com/NLXionaire/nullex-nav-installer/master/NEW_CHANGES"

# Default variables
NET_TYPE=6
INSTALL_TYPE="i"
PORT_NUMBER=46200
RPC_PORT=46000
INSTALL_NUM=1
SWAP=1
FIREWALL=1
FAIL2BAN=1
SYNCCHAIN=1
WAIT_TIMEOUT=5
INSTALL_DIR=""
ETH_INTERFACE="ens3"
WRITE_IP6_CONF=0

# Functions
error_message() {
	echo "${RED}Error:${NONE} $1" && echo && exit
}

welcome_screen() {
	clear
	echo "                 ${GREY}\`.:+shdmNNNNNNmdhyo/-\`"
	echo "             ${GREY}\`-+ymNMMMMMMMNNNNMMMMMMMNmho:\`"
	echo "          ${GREY}\`-odNMMMNdhs+:--.....-:/oydNNMMMmy:\`"
	echo "        ${GREY}\`/hNMMNdy/-\`   \`.-:::-.\`     .:ohNMMMmo-"
	echo "      ${GREY}\`/hNMMmy:\`     -shmNNMNNmhs-      \`.+hNMMms."
	echo "     ${GREY}.yMMMms.     ${RED}\`\` ${GREY}\`+dMMMMMMMmo. ${RED}\`\`       ${GREY}:yNMMmo."
	echo "    ${GREY}:dMMMd:      ${RED}\`/+:\` ${GREY}\`/hNMMd+. ${RED}.:o+\`        ${GREY}:yNMMh:"
	echo "  ${RED}\` ${GREY}\`+dNMMdo\`   ${RED}\`/ssso:. ${GREY}\`/s+\` ${RED}./osss/\`   :-\`  ${GREY}\`/mMMm+\`"
	echo "${RED}\`-+/\` ${GREY}\`/hNMM/   ${RED}-ossssso:\`   \`/ossssso-   -s+:\`  ${GREY}-yMMm-"
	echo "${RED}.oss+.  ${GREY}\`/hN/   ${RED}-osssso/. ${GREY}.-\` ${RED}./osssso.   -osso:\` ${GREY}.oy-"
	echo " ${RED}-+sso:\`  ${GREY}\`:/   ${RED}\`:sso:\` ${GREY}.omNh/\` ${RED}.:oss:     ./osso: ${GREY}\`"
	echo "  ${RED}\`/oss+-\`        ::\` ${GREY}-omMMMMNh/\` ${RED}\`::\`      -+sss/\`"
	echo "   ${RED}\`-+sso+-\`        ${GREY}\`omMMMMMMMMNd/\`       ${RED}-+osso-"
	echo "     ${RED}\`-+osso/.\`      ${GREY}./shmNNNmhs/.     ${RED}.:+osso:\`"
	echo "       ${RED}\`-/ossoo/:.\`     ${GREY}\`..-..\`    ${RED}\`-/+osss+:\`"
	echo "          ${RED}\`-+osssoo++/:--...---:/+oosssoo/.\`"
	echo "             ${RED}\`-:+oosssssssssssssssso+/:.\`"
	echo "                 ${RED}\`\`.-://++oo++//:-.\`${NONE}"
}

help_menu() {
    clear
    echo "${0##*/}, v$SCRIPT_VERSION usage example:"
    echo "sudo sh ${0##*/} [OPTION]"
    echo && echo "Options:" && echo
	echo "  -h, --help"
	echo "            display this help information screen and exit"
	echo "  -t, --type [string]"
	echo "            install type"
	echo "            2 valid options: i = install (default), u = uninstall"
    echo "  -g, --genkey [string]"
	echo "            masternode genkey value"
	echo "            (REQUIRED) script will prompt for this value if not set"
	echo "  -N, --net [integer]"
	echo "            ip address type"
	echo "            2 valid options: 6 = ipv6 (default), 4 = ipv4"
    echo "  -i, --ip [string]"
	echo "            bind node to a specific ipv4 or ipv6 ip address"
	echo "            if left blank and -N = 4 then the main wan ipv4 address will be used"
	echo "            if left blank and -N = 6 then a new ipv6 address will be registered"
    echo "  -p, --port [integer]"
	echo "            node will listen on specific port #"
	echo "            if left blank the port will default to ${PORT_NUMBER} + value of -n"
    echo "  -n, --number [integer]"
	echo "            node install #"
	echo "            default install # is 1"
	echo "            increment this value to set up 2+ nodes"
	echo "            only a single wallet will be installed each time the script is run"
	echo "            valid inputs are 1-99"
    echo "  -s, --noswap"
	echo "            skip creating the disk swap file"
	echo "            default is to install the disk swap file"
	echo "            the swap file only needs to be created once per computer"
	echo "            it is strongly recommended that you do not skip this install"
	echo "            unless you are sure your VPS has enough memory"
	echo "  -f, --nofirewall"
	echo "            skip the firewall setup"
	echo "            default is to install and configure the firewall"
	echo "            it is strongly recommended that you do not skip this install"
	echo "            unless you plan to do the firewall setup manually"
	echo "  -b, --nobruteprotect"
	echo "            skip the brute-force protection setup"
	echo "            default is to install and configure brute-force protection"
	echo "            brute-force protection only needs to be installed once per computer"
	echo "  -c, --nochainsync"
	echo "            skip waiting for the blockchain to sync after installation"
	echo "            default is to wait for the blockchain to fully sync before exiting"
}

begins_with() { case $2 in "$1"*) true;; *) false;; esac; }
contains() { case $2 in *"$1"*) true;; *) false;; esac; }

execute_command() {
	# Ensure that the command is run as the user who initiated the script
	if [ "$USER" != "${CURRENT_USER}" ]; then
		su ${CURRENT_USER} -c "${1}"
	else
		eval "${1}"
	fi
}

validate_genkey() {
	if [ $(printf "%s" "$1" | wc -m) -ne 51 ]; then
		echo "err"
	fi
}

validate_ip4address() {
	IFS=. read a b c d << EOF
	$1
EOF

	if ! ( for i in a b c d; do
			eval test \$$i -gt 0 && eval test \$$i -le 255 || exit 1
		done 2> /dev/null )
	then
		echo "err"
	fi
}

validate_ip6address() {
	if ! (echo $1 | grep -Eq '^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$'); then
		echo "err"
	else
		# Format is valid so now check if the address is already available
		ip -6 addr | grep -qi "$1"
		if [ $? -ne 0 ]; then
			# IP address is not already availble so now check if the this address can be created
			if ! begins_with "${IPV6_INT_BASE}" "$1"; then
				echo "err"
			fi
		fi
	fi
}

validate_port() {
	if [ -z "$1" ] || ([ -n "$1" ] && ((echo $1 | egrep -q '^[0-9]+$' && ([ $1 -lt 1 ] || [ $1 -gt 65535 ])) || ! test "$1" -gt 0 2> /dev/null)); then
		echo "err"
	fi
}

validate_install_num() {
	if [ -z "$1" ] || ([ -n "$1" ] && ((echo $1 | egrep -q '^[0-9]+$' && ([ $1 -lt 1 ] || [ $1 -gt 99 ])) || ! test "$1" -gt 0 2> /dev/null)); then
		echo "err"
	fi
}

check_stop_wallet() {
	# Check if the wallet is currently running
	if [ -f "${HOME_DIR}/${1}/${WALLET_NAME}d" ] && [ -n "$(lsof "${HOME_DIR}/${1}/${WALLET_NAME}d")" ]; then
		# Wallet is running. Issue stop command
		${HOME_DIR}/${1}/${WALLET_NAME}-cli -datadir=${HOME}/.${1} stop >/dev/null 2>&1 && echo
		# Wait for wallet to close		
		PERIOD=".  "

		while [ -f "${HOME_DIR}/${1}/${WALLET_NAME}d" ] && [ -n "$(lsof "${HOME_DIR}/${1}/${WALLET_NAME}d")" ]
		do
			sleep 1 &
			printf "\rWaiting for wallet to close%s" "${PERIOD}"
			case $PERIOD in
				".  ") PERIOD=".. "
				   ;;
				".. ") PERIOD="..."
				   ;;
				*) PERIOD=".  " ;;
			esac			
			wait
		done
		printf "\rWallet closed successfully    " && echo
	fi
}

init_ipv6() {
	# Vultr uses ens3 interface while many other providers use eth0
	# Check for the default interface status
	if [ ! -f /sys/class/net/${ETH_INTERFACE}/operstate ]; then
		# ens3 is not available so try eth0
		ETH_INTERFACE="eth0"
	fi

	# Get the current interface state
	ETH_STATUS=$(cat /sys/class/net/${ETH_INTERFACE}/operstate)

	# Check interface status
	if [ "${ETH_STATUS}" = "down" ] || [ "${ETH_STATUS}" = "" ]; then
		echo && error_message "Cannot use IPv6. Default interface is down"
	fi

	# Check if script is being run on Digital Ocean VPS
	readonly DO_NET_CONF="/etc/network/interfaces.d/50-cloud-init.cfg"
	if [ -f ${DO_NET_CONF} ]; then
		# Script is running on Digital Ocean
		if ! grep -q "::8888" ${DO_NET_CONF}; then
			# Apply IPv6 fix (only necessary for Digital Ocean installs)
			echo && echo "${CYAN}#####${NONE} Applying IPv6 fix ${CYAN}#####${NONE}" && echo
			sed -i '/iface eth0 inet6 static/a dns-nameservers 2001:4860:4860::8844 2001:4860:4860::8888 8.8.8.8 127.0.0.1' ${DO_NET_CONF} >/dev/null 2>&1
			ifdown ${ETH_INTERFACE} >/dev/null 2>&1
			ifup ${ETH_INTERFACE} >/dev/null 2>&1
		fi
	fi

	# Get the base IPv6 address
	IPV6_INT_BASE="$(ip -6 addr show dev ${ETH_INTERFACE} | grep inet6 | awk -F '[ \t]+|/' '{print $3}' | grep -v ^fe80 | grep -v ^::1 | cut -f1-4 -d':' | head -1)"

	if [ -z "${IPV6_INT_BASE}" ]; then
		echo && error_message "No IPv6 support found. Did you forget to enable it during installation?"
	fi
}

# Verify that user has root
if [ "$(whoami)" != "root" ]; then
	echo && error_message "${ORANGE}Root${NONE} privileges not detected. This script must be run using the keyword '${CYAN}sudo${NONE}' to enable ${ORANGE}root${NONE} user"
fi

# Check linux version
LINUX_VERSION=$(cat /etc/issue.net)
if ! contains "16.04" "$LINUX_VERSION"; then
	echo && echo "Your linux version: ${ORANGE}$LINUX_VERSION${NONE}"
	echo "This script has been designed to run on ${GREEN}Ubuntu 16.04${NONE}."
	echo "Would you like to continue installing anyway? [y/n]: ";
	read -p "" INSTALL_ANSWER
	
    case "$INSTALL_ANSWER" in
        [yY]) ;;
        *) exit ;;
    esac
fi

# Read command line arguments
if ! ARGS=$(getopt -o "ht:g:N:i:p:n:sfbc" -l "help,type:,genkey:,net:,ip:,port:,number:,noswap,nofirewall,nobruteprotect,nochainsync" -n "${0##*/}" -- "$@"); then
	# invalid command line arguments so show help menu
	help_menu
	exit;
fi

eval set -- "$ARGS";

while true; do
    case "$1" in
        -h|--help)
            shift;
            help_menu;
			exit
            ;;
        -t|--type)
            shift;
			if [ -n "$1" ];
			then
				INSTALL_TYPE="$1";
				shift;
			fi
            ;;
        -g|--genkey)
            shift;
			if [ -n "$1" ];
			then
				NULLGENKEY="$1";
				shift;
			fi
            ;;
        -N|--net)
            shift;
			if [ -n "$1" ];
			then
				NET_TYPE="$1";
				shift;
			fi
            ;;
        -i|--ip)
            shift;
			if [ -n "$1" ];
			then
				WAN_IP="$1";
				shift;
			fi
            ;;
        -p|--port)
            shift;
			if [ -n "$1" ];
			then
				PORT_NUMBER_ARG="$1";
				shift;
			fi
            ;;
        -n|--number)
            shift;
			if [ -n "$1" ];
			then
				INSTALL_NUM="$1";
				shift;
			fi
            ;;
        -s|--noswap)
            shift;
            SWAP="0";
            ;;
        -f|--nofirewall)
            shift;
            FIREWALL="0";
            ;;
        -b|--nobruteprotect)
            shift;
            FAIL2BAN="0";
            ;;
        -c|--nochainsync)
            shift;
            SYNCCHAIN="0";
            ;;
        --)
            shift;
            break;
            ;;
    esac
done

# Validate command line arguments

case $NET_TYPE in
	4) ;;
	6) ;;
	*) echo && error_message "Invalid ip address type" ;;
esac

case $INSTALL_TYPE in
	i) INSTALL_TYPE="Install"
	   ;;
	I) INSTALL_TYPE="Install"
	   ;;
	u) INSTALL_TYPE="Uninstall"
	   ;;
	U) INSTALL_TYPE="Uninstall"
	   ;;
	*) echo && error_message "Invalid install type" ;;
esac

if [ "$INSTALL_TYPE" = "Install" ]; then
	if [ -n "$NULLGENKEY" ] && [ -n "$(validate_genkey $NULLGENKEY)" ]; then
		echo && error_message "Invalid masternode genkey value"
	fi
	
	if [ "$NET_TYPE" -eq 6 ]; then
		# Setup IPv6 support before validating ip address
		init_ipv6
	fi
	
	if [ -n "$WAN_IP" ] && (([ "$NET_TYPE" -eq 4 ] && [ -n "$(validate_ip4address $WAN_IP)" ]) || ([ "$NET_TYPE" -eq 6 ] && [ -n "$(validate_ip6address $WAN_IP)" ])); then
		echo && error_message "Invalid ip address"
	fi

	if [ -n "$PORT_NUMBER_ARG" ]; then
		if [ -n "$(validate_port $PORT_NUMBER_ARG)" ]; then
			echo && error_message "Invalid port #"
		else
			PORT_NUMBER=$PORT_NUMBER_ARG
		fi
	else
		PORT_NUMBER=$(( $PORT_NUMBER + $INSTALL_NUM ))
	fi
fi

if [ -n "$INSTALL_NUM" ] && [ -n "$(validate_install_num $INSTALL_NUM)" ]; then
	echo && error_message "Invalid install #"
fi

# Get the current user id for later
readonly CURRENT_USER_ID=$(execute_command "id -ur")
# Welcome
welcome_screen
echo && echo "${GREY}///////////////////////////////////////////////////////"
echo "${NONE}      Nullex Null Array Verifier (NAV) Installer       "
echo -n "${GREY}///////////////////////////////////////////////////////${NONE}"
# Check for an updated version of the script
sleep 2 && echo
echo && echo "${CYAN}#####${NONE} Check for script update ${CYAN}#####${NONE}" && echo
NEWEST_VERSION=$(curl -s -k "${VERSION_URL}")
VERSION_LENGTH=$(printf "%s" "${NEWEST_VERSION}" | wc -m)

if [ ${VERSION_LENGTH} -gt 0 ] && [ ${VERSION_LENGTH} -lt 10 ] && [ "${SCRIPT_VERSION}" != "${NEWEST_VERSION}" ]; then
	# A new version of the script is available
	echo "${CYAN}Current script:${NONE}	v${SCRIPT_VERSION}"
	echo "${CYAN}New script:${NONE} 	v${NEWEST_VERSION}"
	echo && echo "${CYAN}CHANGES:${NONE}"
	echo "$(curl -s -k "${NEW_CHANGES_URL}")"
	echo && echo -n "Would you like to update now? [y/n]: "
	read -p "" UPDATE_NOW
    case "$UPDATE_NOW" in
        [yY])
			# Update to newest version of script
			echo "Updating, please wait..."
			 Overwrite the current script with the newest version
			{
				echo "$(curl -s -k "${SCRIPT_URL}")"
			} > ${0}
			# Fix parameters before restarting
			case $INSTALL_TYPE in
				"Install") INSTALL_TYPE="i" ;;
				*) INSTALL_TYPE="u" ;;
			esac
			if [ -n "$NULLGENKEY" ]; then
				NULLGENKEY=" -g ${NULLGENKEY}"
			fi			
			if [ -n "$WAN_IP" ]; then
				WAN_IP=" -i ${WAN_IP}"
			fi
			if [ -n "$PORT_NUMBER" ]; then
				PORT_NUMBER=" -p ${PORT_NUMBER}"
			fi
			if [ "$SWAP" -eq 0 ]; then
				SWAP=" -s"
			else
				SWAP=""
			fi
			if [ "$FIREWALL" -eq 0 ]; then
				FIREWALL=" -f"
			else
				FIREWALL=""
			fi
			if [ "$FAIL2BAN" -eq 0 ]; then
				FAIL2BAN=" -b"
			else
				FAIL2BAN=""
			fi
			if [ "$SYNCCHAIN" -eq 0 ]; then
				SYNCCHAIN=" -c"
			else
				SYNCCHAIN=""
			fi
			# Restart the newest version of the script
			eval "sh ${0} -t ${INSTALL_TYPE}${NULLGENKEY} -N ${NET_TYPE}${WAN_IP}${PORT_NUMBER} -n ${INSTALL_NUM}${SWAP}${FIREWALL}${FAIL2BAN}${SYNCCHAIN}"
			exit
			;;
    esac
else
	echo "No new update found"
fi

# Collect the masternode genkey value (if not already specified via command line)
if [ -z "$NULLGENKEY" ] && [ "$INSTALL_TYPE" = "Install" ]; then
	echo && echo -n "Enter the masternode genkey value and press 'ENTER': "
	read -p "" NULLGENKEY

	if [ -z "$NULLGENKEY" ] || ([ -n "$NULLGENKEY" ] && [ -n "$(validate_genkey $NULLGENKEY)" ]); then
		echo && error_message "Invalid masternode genkey value"
	fi
fi

# Get IP Address (if not already specified via command line)
if [ -z "$WAN_IP" ]; then
	if [ "$NET_TYPE" -eq 4 ]; then
		# Get the default external IPv4 ip address
		WAN_IP=$(curl -s -k http://icanhazip.com --ipv4)
	else
		# Build the IPv6 ip address
		WAN_IP="${IPV6_INT_BASE}:${NETWORK_BASE_TAG}::${INSTALL_NUM}"
	fi
fi

echo && echo "${ULINE}${CYAN}${INSTALL_TYPE} Settings:${NONE}" && echo

if [ "$INSTALL_NUM" -eq 1 ]; then
	INSTALL_DIR="${DATA_DIR}"
else
	INSTALL_DIR="${DATA_DIR}${INSTALL_NUM}"
fi

if [ "$INSTALL_TYPE" = "Install" ]; then
	echo "${CYAN}New Wallet Version:${NONE}	v$WALLET_VERSION"
	
	if [ -f ${HOME}/.${INSTALL_DIR}/${DATA_DIR}.conf ]; then
		echo "${CYAN}Install Type:${NONE}		UPDATE"
	else
		echo "${CYAN}Install Type:${NONE}		NEW INSTALL"
	fi
	
	echo "${CYAN}Genkey Value:${NONE}		$NULLGENKEY"
	echo "${CYAN}IP Address:${NONE}		$WAN_IP"
	echo "${CYAN}Port #:${NONE}			$PORT_NUMBER"
	echo "${CYAN}Install Directory:${NONE}	${HOME_DIR}/${INSTALL_DIR}"

	if [ "$SWAP" -eq 0 ]; then
		echo "${CYAN}Disk Swap:${NONE}		${ORANGE}No${NONE}"
	else
		echo "${CYAN}Disk Swap:${NONE}		Yes"
	fi

	if [ "$FIREWALL" -eq 0 ]; then
		echo "${CYAN}Firewall:${NONE}		${ORANGE}No${NONE}"
	else
		echo "${CYAN}Firewall:${NONE}		Yes"
	fi

	if [ "$FAIL2BAN" -eq 0 ]; then
		echo "${CYAN}Brute-Force Protection:${NONE}	${ORANGE}No${NONE}"
	else
		echo "${CYAN}Brute-Force Protection:${NONE}	Yes"
	fi

	if [ "$BLOCKCOUNT_URL" = "" ]; then
		echo "${CYAN}Blockchain Sync:${NONE}	${ORANGE}No (Block explorer not found)${NONE}"
	else
		if [ "$SYNCCHAIN" -eq 0 ]; then
			echo "${CYAN}Blockchain Sync:${NONE}	${ORANGE}No${NONE}"
		else
			echo "${CYAN}Blockchain Sync:${NONE}	Yes"
		fi
	fi
	
	# Wait for timeout

	IFS=:
	set -- $*
	echo
	while [ $WAIT_TIMEOUT -gt 0 ]
	do
		sleep 1 &
		printf "\rInstallation will continue in: %01d..." ${WAIT_TIMEOUT}
		WAIT_TIMEOUT=`expr $WAIT_TIMEOUT - 1`
		wait
	done
	printf "\r                                      "

	## Update package lists, repositories and new software versions
	#echo && echo "${CYAN}#####${NONE} Updating package lists, repositories and new software versions ${CYAN}#####${NONE}" && echo
	#apt-get update -y && apt-get upgrade -y && echo
	
	if [ "$SWAP" -eq 1 ]; then
		# Install and configure disk swap file
		
		if [ -z "$({ fallocate -l 4G /swapfile; } 2>&1)" ]; then
			echo "${CYAN}#####${NONE} Configuring disk swap file ${CYAN}#####${NONE}" && echo
			chmod 600 /swapfile
			mkswap /swapfile >/dev/null 2>&1
			swapon /swapfile
			grep -q "/swapfile none swap sw 0 0" /etc/fstab; [ $? -eq 1 ] && bash -c "echo '/swapfile none swap sw 0 0' >> /etc/fstab"
			bash -c "echo 'vm.swappiness = 10' >> /etc/sysctl.conf"
			echo "Done" && echo
		else
			echo "${ORANGE}#####${NONE} Disk swap already configured ${ORANGE}#####${NONE}" && echo
		fi
	fi

	if [ "$FIREWALL" -eq 1 ]; then
		# Check if firewall is already installed
		if [ -z "$({ dpkg -l | grep -E '^ii' | grep ufw; })" ]; then
			# Install firewall
			echo "${CYAN}#####${NONE} Install firewall ${CYAN}#####${NONE}" && echo
			apt-get install ufw -y
			
			# Check to ensure firewall was installed
			if [ -z "$({ dpkg -l | grep -E '^ii' | grep ufw; })" ]; then
				echo && error_message "Failed to install firewall"
			fi
		fi

		# Configure firewall
		echo "${CYAN}#####${NONE} Configure firewall ${CYAN}#####${NONE}" && echo
		ufw default allow outgoing
		ufw default deny incoming
		ufw allow OpenSSH
		ufw limit OpenSSH
		ufw allow ${PORT_NUMBER}
		ufw logging on
		ufw --force enable && echo
	fi

	if [ "$FAIL2BAN" -eq 1 ]; then
		# Check if brute-force protection is already installed
		if [ -z "$({ dpkg -l | grep -E '^ii' | grep fail2ban; })" ]; then
			# Install brute-force protection
			echo "${CYAN}#####${NONE} Install brute-force protection ${CYAN}#####${NONE}" && echo
			apt-get install fail2ban -y && echo
			
			# Check to ensure brute-force protection was installed
			if [ -z "$({ dpkg -l | grep -E '^ii' | grep fail2ban; })" ]; then
				echo && error_message "Failed to install brute-force protection"
			fi
		fi

		# Configure brute-force protection
		echo "${CYAN}#####${NONE} Configure brute-force protection ${CYAN}#####${NONE}" && echo
		systemctl enable fail2ban
		systemctl start fail2ban && echo
	fi

	if [ -z "$({ dpkg -l | grep -E '^ii' | grep pwgen; })" ]; then
		# Install password generator
		echo "${CYAN}#####${NONE} Install password generator (required for wallet setup) ${CYAN}#####${NONE}" && echo
		sleep 2
		apt-get install pwgen -y && echo
		
		# Check to ensure password generator was installed
		if [ -z "$({ dpkg -l | grep -E '^ii' | grep pwgen; })" ]; then
			echo && error_message "Failed to install password generator"
		fi
	fi

	if [ "$NET_TYPE" -eq 4 ]; then
		# IPv4 address setup
		CONFIG_ADDRESS="${WAN_IP}:${PORT_NUMBER}"
	else
		# IPv6 address setup
		CONFIG_ADDRESS="[${WAN_IP}]:${PORT_NUMBER}"

		# Check if IPv6 address is already available
		if [ -z "$({ ip -6 addr | grep -i "${WAN_IP}"; })" ]; then
			# IPv6 address is not already available
			echo "${CYAN}#####${NONE} Registering new IPv6 address: ${WAN_IP} ${CYAN}#####${NONE}" && echo
			# Add new IPv6 address to the system
			ip -6 addr add "${WAN_IP}/64" dev ${ETH_INTERFACE} >/dev/null 2>&1
			if [ $? -eq 0 ]; then
				# New ip address registered successfully
				# Remember the ip6 address for later
				WRITE_IP6_CONF=1
				sleep 2
				echo "Done" && echo
			else
				# Error while trying to create the IPv6 adddress
				error_message "Unable to create IPv6 address"
			fi
		fi
	fi

	# Check if wallet is currently running and stop it if running
	if [ -f "${HOME_DIR}/${INSTALL_DIR}/${WALLET_NAME}d" ] && [ -n "$(lsof "${HOME_DIR}/${INSTALL_DIR}/${WALLET_NAME}d")" ]; then
		# Wallet is running. Issue stop command
		echo "${CYAN}#####${NONE} Close wallet ${CYAN}#####${NONE}"
		check_stop_wallet ${INSTALL_DIR} && echo
	fi

	# Now that the wallet is not running, delete the old wallet files
	rm -f "${HOME_DIR}/${INSTALL_DIR}/${WALLET_NAME}d"
	rm -f "${HOME_DIR}/${INSTALL_DIR}/${WALLET_NAME}-cli"
	
	# Check if there is already a saved wallet available instead of downloading a new one again
	WALLET_DIR="${HOME_DIR}"
	i=1; while [ $i -le 99 ]; do
		case $i in
			1) DIR_TEST="${DATA_DIR}" ;;
			*) DIR_TEST="${DATA_DIR}${i}" ;;
		esac
		
		if [ -d "${HOME_DIR}/${DIR_TEST}" ]; then
			# Remove all old wallet backups from this install directory
			find ${HOME_DIR}/${DIR_TEST} -name "*.tar.gz" ! -name "${WALLET_FILE}" -type f -exec rm -f {} +

			# Check if this install directory has a copy of the current wallet
			if [ "$WALLET_DIR" = "${HOME_DIR}" ] && [ -d "${HOME_DIR}/${DIR_TEST}" ] && [ -f "${HOME_DIR}/${DIR_TEST}/${WALLET_FILE}" ]; then
				# Found a copy of the current wallet
				# Save wallet directory
				WALLET_DIR="${HOME_DIR}/${DIR_TEST}"
			fi
		fi
		
		i=$(( i + 1 ))
	done
	
	if [ "$WALLET_DIR" = "${HOME_DIR}" ]; then
		# Download wallet
		echo "${CYAN}#####${NONE} Download wallet ${CYAN}#####${NONE}" && echo
		wget -q "${WALLET_URL}${WALLET_FILE}" -O "${WALLET_DIR}/${WALLET_FILE}" --show-progress

		# Ensure wallet downloaded successfully
		if [ ! -f "${WALLET_DIR}/${WALLET_FILE}" ] || [ $(stat -c%s "${WALLET_DIR}/${WALLET_FILE}") -eq 0 ]; then
			error_message "Failed to download wallet"
		fi
		echo
	fi

	# Extract wallet files
	echo "${CYAN}#####${NONE} Extract wallet files ${CYAN}#####${NONE}" && echo
	tar -zxvf "${WALLET_DIR}/${WALLET_FILE}" -C "${HOME_DIR}" && echo

	# Wallet setup	
	echo "${CYAN}#####${NONE} Wallet setup ${CYAN}#####${NONE}" && echo

	# Create wallet directory if not exists
	if [ ! -d "${HOME_DIR}/${INSTALL_DIR}" ]; then
		mkdir "${HOME_DIR}/${INSTALL_DIR}"
	fi
	
	if [ $WRITE_IP6_CONF -eq 1 ]; then
		# Create a small file in the wallet directory to be used for removal of ip6 address at a later time
		echo 'ip -6 addr add '"${IPV6_INT_BASE}"':'"${NETWORK_BASE_TAG}"'::'"${INSTALL_NUM}"'/64 dev '"${ETH_INTERFACE}"'' > ${HOME_DIR}/${INSTALL_DIR}/.ip6.conf
	fi
	
	# Create a small script that will be used to auto-start the wallet on reboot (also init IPv6 address if necessary)
	{
		echo "#!/bin/bash"
		echo 'readonly CURRENT_USER="${1}"'
		echo
		echo "execute_command() {"
		echo '	if [ "$USER" != "${CURRENT_USER}" ]; then'
		echo '		su ${CURRENT_USER} -c "${1}"'
		echo '	else'
		echo '		eval "${1}"'
		echo '	fi'
		echo "}"
		
		if [ $WRITE_IP6_CONF -eq 1 ]; then
			# Extend the script to also initialize the IPv6 address on reboot before starting the wallet
			echo
			echo 'readonly WAN_IP="'"${WAN_IP}"'"'
			echo 'ETH_INTERFACE="ens3"'
			echo
			echo 'if [ -n "${WAN_IP}" ]; then'
			echo '	if [ ! -f /sys/class/net/${ETH_INTERFACE}/operstate ]; then'
			echo '		ETH_INTERFACE="eth0"'
			echo '	fi'
			echo
			echo '	ETH_STATUS=$(cat /sys/class/net/${ETH_INTERFACE}/operstate)'
			echo
			echo '	if [ "${ETH_STATUS}" = "up" ]; then'
			echo '		while [ -z "${IPV6_INT_BASE}" ]; do'
			echo '			sleep 1'
			echo '			IPV6_INT_BASE="$(ip -6 addr show dev ${ETH_INTERFACE} | grep inet6 | awk -F '"'"'[ \t]+|/'"'"' '"'"'{print $3}'"'"' | grep -v ^fe80 | grep -v ^::1 | cut -f1-4 -d'"'"':'"'"' | head -1)"'
			echo '			wait'
			echo '		done'
			echo
			echo '		if [ -z "$({ ip -6 addr | grep -i "${WAN_IP}"; })" ]; then'
			echo '			ip -6 addr add "${WAN_IP}/64" dev ${ETH_INTERFACE} >/dev/null 2>&1'
			echo '			if [ $? -eq 0 ]; then'
			echo '				sleep 2'
			echo '			fi'
			echo '		fi'
			echo '	fi'
			echo 'fi'
		fi
		
		echo
		echo 'execute_command "'"${HOME_DIR}"'/'"${INSTALL_DIR}"'/'"${WALLET_NAME}"'d -datadir='"${HOME}"'/.'"${INSTALL_DIR}"' -daemon"'
	} > ${HOME_DIR}/${INSTALL_DIR}/.reboot.sh
	
	# Backup the current rc.local file
	cp ${RC_LOCAL} ${RC_LOCAL}.$(date +%Y-%b-%d-%s).bak
	# Ensure that the rc.local file is executable
	chmod +x ${RC_LOCAL}
	# Ensure that the wallet automatically starts up after reboot
	sed -e '$i '"${HOME_DIR}"'/'"${INSTALL_DIR}"'/.reboot.sh "'"${CURRENT_USER}"'" &' -i ${RC_LOCAL}

	if [ "${ARCHIVE_DIR}" = "" ]; then
		# Move extracted files from the home directory to the install directory
		mv "${HOME_DIR}/${WALLET_NAME}d" "${HOME_DIR}/${INSTALL_DIR}/${WALLET_NAME}d"
		mv "${HOME_DIR}/${WALLET_NAME}-cli" "${HOME_DIR}/${INSTALL_DIR}/${WALLET_NAME}-cli"
	else
		# Find the proper files from within the extracted directory and move them to the install directory
		find ${HOME_DIR}/${ARCHIVE_DIR} -name "${WALLET_NAME}d" -type f -exec mv {} "${HOME_DIR}/${INSTALL_DIR}/" \;
		find ${HOME_DIR}/${ARCHIVE_DIR} -name "${WALLET_NAME}-cli" -type f -exec mv {} "${HOME_DIR}/${INSTALL_DIR}/" \;
		# Remove extracted directory
		rm -rf "${HOME_DIR}/${ARCHIVE_DIR}"
	fi
	
	# Mark wallet files and scripts as executable
	chmod +x ${HOME_DIR}/${INSTALL_DIR}/${WALLET_NAME}d
	chmod +x ${HOME_DIR}/${INSTALL_DIR}/${WALLET_NAME}-cli
	chmod +x ${HOME_DIR}/${INSTALL_DIR}/.reboot.sh
	
	if [ "$WALLET_DIR" = "${HOME_DIR}" ]; then
		# Save a copy of the downloaded wallet into the current install directory
		mv "${WALLET_DIR}/${WALLET_FILE}" "${HOME_DIR}/${INSTALL_DIR}/${WALLET_FILE}"
	fi

	# Check if the config file already exists (if yes, this is most likely an upgrade install)
	if [ ! -f ${HOME}/.${INSTALL_DIR}/${DATA_DIR}.conf ]; then
		# The config file does not exist
		if [ ! -d "${HOME}/.${INSTALL_DIR}" ]; then
			# Manually create the data directory
			execute_command "mkdir ${HOME}/.${INSTALL_DIR}"
		fi

		if [ "${REQUIRE_GENERATE_CONF}" -eq 1 ]; then
			# Generate new data files for this install
			execute_command "${HOME_DIR}/${INSTALL_DIR}/${WALLET_NAME}d -datadir=${HOME}/.${INSTALL_DIR} >/dev/null 2>&1"
		fi

		# Check if there is another install that can be copied over to save time on re-syncing the blockchain
		i=1; while [ $i -le 99 ]; do
			case $i in
				1) DIR_TEST="${DATA_DIR}" ;;
				*) DIR_TEST="${DATA_DIR}${i}" ;;
			esac
			
			if [ -d "${HOME}/.${DIR_TEST}" ] && [ ".${DIR_TEST}" != ".${INSTALL_DIR}" ]; then
				# Found another data directory
				# Delete the necessary files from the current data directory
				rm -rf "${HOME}/.${INSTALL_DIR}/blocks"
				rm -rf "${HOME}/.${INSTALL_DIR}/chainstate"
				NEED_RESTART=0

				# Check if the other wallet is currently running and stop it if running
				if [ -f "${HOME_DIR}/${DIR_TEST}/${WALLET_NAME}d" ] && [ -n "$(lsof "${HOME_DIR}/${DIR_TEST}/${WALLET_NAME}d")" ]; then
					# Wallet is running. Issue stop command
					echo "Temporarily closing wallet #${i}\c"
					check_stop_wallet ${DIR_TEST}
					NEED_RESTART=1
				fi

				# Copy blockchain files from the other data directory
				echo "Copy blockchain from wallet #${i}"
				execute_command "cp -rf ${HOME}/.${DIR_TEST}/blocks ${HOME}/.${INSTALL_DIR}/blocks"
				execute_command "cp -rf ${HOME}/.${DIR_TEST}/chainstate ${HOME}/.${INSTALL_DIR}/chainstate"
				execute_command "sync && wait"

				# Check if other wallet needs to be restarted
				if [ $NEED_RESTART -eq 1 ]; then
					# Restart other wallet
					echo "Restart wallet #${i}"
					execute_command "${HOME_DIR}/${DIR_TEST}/${WALLET_NAME}d -datadir=${HOME}/.${DIR_TEST} -daemon"
				fi
				
				# Return from loop
				break
			fi
			
			i=$(( i + 1 ))
		done
	fi

	# Overwrite configuration file settings
	{
		echo "rpcuser=${WALLET_NAME}rpc${INSTALL_NUM}"
		echo "rpcpassword=$(pwgen -s 32 1)"
		echo "rpcallowip=127.0.0.1"
		echo "rpcport=$(( $RPC_PORT + $INSTALL_NUM ))"
		echo "listen=1"
		echo "server=1"
		echo "daemon=1"
		echo "maxconnections=256"
		echo "masternode=1"
		echo "logtimestamps=1"
		echo "masternodeprivkey=$NULLGENKEY"
		echo "nullarrayprivkey=$NULLGENKEY"
		echo "nullarrayaddr=${CONFIG_ADDRESS}"
		echo "externalip=${CONFIG_ADDRESS}"
		echo "bind=${CONFIG_ADDRESS}"
	} > ${HOME}/.${INSTALL_DIR}/${DATA_DIR}.conf
	# Wallet setup complete
	echo "Wallet setup complete" && echo
	# Start Wallet
	echo "${CYAN}#####${NONE} Start Wallet ${CYAN}#####${NONE}" && echo
	execute_command "${HOME_DIR}/${INSTALL_DIR}/${WALLET_NAME}d -datadir=${HOME}/.${INSTALL_DIR} -daemon"
	# Wait for wallet to load
	echo && echo "${CYAN}#####${NONE} Wait for wallet to load ${CYAN}#####${NONE}" && echo
	CURRENT_BLOCKS=""
	PERIOD=".  "

	# Wait for the wallet to fully load (getblockcount will return an error instead of a numeric block value until loaded)
	while ! (echo ${CURRENT_BLOCKS} | egrep -q '^[0-9]+$'); do
		sleep 1 &
		printf "\rWaiting for wallet to load%s" "${PERIOD}"
		CURRENT_BLOCKS=$("${HOME_DIR}/${INSTALL_DIR}/${WALLET_NAME}-cli" -datadir="${HOME}/.${INSTALL_DIR}" getblockcount) >/dev/null 2>&1

		case $PERIOD in
			".  ") PERIOD=".. "
			   ;;
			".. ") PERIOD="..."
			   ;;
			*) PERIOD=".  " ;;
		esac && wait
	done
	printf "\rWallet loaded successfully   " && echo
	
	# If there is an active block explorer to check, the last step is to wait for the wallet to fully sync with the network (if not skipped)
	if [ "$SYNCCHAIN" -eq 1 ] && [ -n "${BLOCKCOUNT_URL}" ]; then
		# Ensure blockcount url returns a proper value
		TOTAL_BLOCKS=$(curl -s -k "${BLOCKCOUNT_URL}")

		if (echo ${TOTAL_BLOCKS} | egrep -q '^[0-9]+$'); then
			# Wait for the wallet to sync
			echo && echo "${CYAN}#####${NONE} Wait for blocks to sync ${CYAN}#####${NONE}" && echo
			printf "\rSyncing: %s (?.?? %%)" "${CURRENT_BLOCKS}/?"
			TOTAL_BLOCKS=$(curl -s -k "${BLOCKCOUNT_URL}")
			SECONDS=0
			
			while [ $CURRENT_BLOCKS -lt $TOTAL_BLOCKS ]; do
				sleep 1
				SECONDS=`expr $SECONDS + 1`
				
				if [ "$SECONDS" -gt 60 ]; then
					# Re-get the total blocks from the block explorer every minute and reset the seconds counter
					TOTAL_BLOCKS=$(curl -s -k "${BLOCKCOUNT_URL}")
					SECONDS=0
				fi
				
				CURRENT_BLOCKS=$(${HOME_DIR}/${INSTALL_DIR}/${WALLET_NAME}-cli -datadir=${HOME}/.${INSTALL_DIR} getblockcount)
				printf "\rSyncing: %s (%.2f %%)" "${CURRENT_BLOCKS}/${TOTAL_BLOCKS}" $(awk "BEGIN { print 100*${CURRENT_BLOCKS}/${TOTAL_BLOCKS} }")
				wait
			done
			printf "\rSyncing: %s (%.2f %%)" "${TOTAL_BLOCKS}/${TOTAL_BLOCKS}" $(awk "BEGIN { print 100*${TOTAL_BLOCKS}/${TOTAL_BLOCKS} }") && echo
		else
			# The block explorer isn't working
			echo && echo "${ORANGE}#####${NONE} ${BLOCKCOUNT_URL} is down ${ORANGE}#####${NONE}"
			echo "${ORANGE}#####${NONE} Blockchain sync will continue in the background ${ORANGE}#####${NONE}"
		fi
	fi
	
	# Output the list of useful commands for the newly installed wallet
	echo && echo "${CYAN}#####${NONE} Useful commands ${CYAN}#####${NONE}" && echo
	
	if [ "$INSTALL_NUM" -eq 1 ]; then
		echo "${CYAN}Uninstall wallet:${NONE} sudo sh ${0##*/} -t u"
		echo "${CYAN}Manually stop wallet:${NONE} ${HOME_DIR}/${INSTALL_DIR}/${WALLET_NAME}-cli stop"
		echo "${CYAN}Manually start wallet:${NONE} ${HOME_DIR}/${INSTALL_DIR}/${WALLET_NAME}d -daemon"
	else
		echo "${CYAN}Uninstall wallet:${NONE} sudo sh ${0##*/} -t u -n $INSTALL_NUM"
		echo "${CYAN}Manually stop wallet:${NONE} ${HOME_DIR}/${INSTALL_DIR}/${WALLET_NAME}-cli -datadir=${HOME}/.${INSTALL_DIR} stop"
		echo "${CYAN}Manually start wallet:${NONE} ${HOME_DIR}/${INSTALL_DIR}/${WALLET_NAME}d -datadir=${HOME}/.${INSTALL_DIR} -daemon"
	fi
else
	# Check to ensure this wallet # is actually installed	
	if [ ! -d "${HOME_DIR}/${INSTALL_DIR}" ] && [ ! -d "${HOME}/.${INSTALL_DIR}" ]; then
		# Wallet is not installed		
		error_message "Cannot find installed wallet in ${HOME_DIR}/${INSTALL_DIR}"
	fi

	echo "The following directories will be deleted:" && echo
	echo "${CYAN}Wallet Directory:${NONE}		${HOME_DIR}/${INSTALL_DIR}"
	echo "${CYAN}Data Directory:${NONE}			${HOME}/.${INSTALL_DIR}"
	echo && echo -n "Are you sure you want to completely uninstall the wallet? [y/n]: "
	read -p "" UNINSTALL_ANSWER
	
    case "$UNINSTALL_ANSWER" in
        [yY]) ;;
        *) exit ;;
    esac
	
	# Check if wallet is currently running and stop it if running	
	check_stop_wallet ${INSTALL_DIR}

	# Check if the wallet created an IPv6 address
	if [ -f "${HOME_DIR}/${INSTALL_DIR}/.ip6.conf" ]; then
		# Initialize IPv6 variables for use below
		init_ipv6
		# Unregister the IPv6 address
		ip -6 addr del "${IPV6_INT_BASE}:${NETWORK_BASE_TAG}::${INSTALL_NUM}/64" dev ${ETH_INTERFACE} >/dev/null 2>&1
	fi
	
	# Backup the current rc.local file
	cp ${RC_LOCAL} ${RC_LOCAL}.$(date +%Y-%b-%d-%s).bak
	# Remove the reboot script for this wallet from the rc.local file
	grep -v "${HOME_DIR}/${INSTALL_DIR}/.reboot.sh" ${RC_LOCAL} > ${RC_LOCAL}.new; mv ${RC_LOCAL}.new ${RC_LOCAL}

	# Remove the wallet and data directories
	rm -rf "${HOME_DIR}/${INSTALL_DIR}"
	rm -rf "${HOME}/.${INSTALL_DIR}"
fi

echo && echo "${GREEN}#####${NONE} ${INSTALL_TYPE}ation complete ${GREEN}#####${NONE}" && echo
