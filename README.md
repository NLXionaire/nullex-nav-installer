# NulleX NAV Installer

### v1.0.7
#### IMPORTANT NOTE:
The install script was written with the ability to install multiple NAV's in parallel on the same VPS but the NulleX wallet specifically does not allow this configuration (yet). If and when a solution to this problem is discovered, this script already contains full support for running multiple NAV's on the same VPS and will "just work" if the wallets themselves can be updated to get around this problem.

## General Information

A custom masternode install script made from scratch specifically for installing Nullex NAVs.

Currently, it must be run on Ubuntu Linux 16.04 and has been tested to work using VPS systems from vultr.com and lunanode.com only but should be generic enough to run anywhere (Please let @NLXionaire know your experience in https://t.me/NullexOfficial or https://discord.gg/YrzChXX if you have tried with another VPS provider).

Since this script has the potential to install "extra" software components such as a firewall and/or create a swap disk file, root privileges are required to install properly. Therefore, you must either run the script using the `sudo` command prefix or else run directly as the root user (generally not recommended for security reasons but still supported).

All wallets are installed to the /usr/local/bin directory.

To save time on 2+ installs, the wallet binaries are archived in the wallet directory (typically /usr/local/bin/NulleX) after the first successful install and those locally stored files are then used to install subsequent wallet installs in much less time than the first.

## Features

- Supports installing, updating or uninstalling up to 99 Nullex Nav installs on the same VPS
- IPv4 and IPv6 support
- Script update feature ensures you are always installing using the most up-to-date script
- Wallet update feature ensures you do not have to wait for an updated script to be released to install the latest wallet version
- Install wallet from compiled binary files or build from source code
- Faster syncing times for 2+ installs by copying previously installed blockchain files over to new installs
- Automatic restart of installed Navs after reboot
- Install additional setup components such as swap disk file, firewall configuration and brute-force protection
- Automatic generation of genkey value provides heightened security with less user interaction
- Visualize the blockchain sync process after installation to ensure wallet(s) are all caught up with current block counts
- Custom ascii art Nullex logo

## Future Features/Known Issues

- Updating a previously installed wallet needs to remove previous settings before applying new settings
- Updating a previously installed wallet needs to be smart enough to get the current configuration values instead of using 'new install' defaults
- Properly shutdown all wallets automatically when a reboot or shutdown command is issued to prevent blockchain corruption
- Automatically remove firewall rules for port(s) that pertain to a specific wallet install when the wallet is uninstalled

## Available Command-Line Options

- -h or --help

     Displays the help menu

     Usage Example: `sudo sh nullex-nav-installer.sh -h`
- -t or --type

     Install type. There are 2 valid options: i = install (default), u = uninstall
     
     Usage Example: `sudo sh nullex-nav-installer.sh -t i`
- -w or --wallet

     Wallet type. There are 2 valid options: d = download (default), b = build from source
     
     Usage Example: `sudo sh nullex-nav-installer.sh -w b`
- -g or --genkey

     The masternode genkey value. Generate this with the `masternode genkey` command either automatically from the VPS wallet (recommended) or from your hot wallet in the Debug Console). If left blank the value will be autogenerated
     
     Usage Example: `sudo sh nullex-nav-installer.sh -g 88pgtdc9rgiEFMarhuVAdDjeDBUiPbFPhqdafFsBUKcgS3XovPc`
- -N or --net

     IP address type. There are 2 valid options: 6 = IPv6 (default), 4 = IPv4
     
     Usage Example: `sudo sh nullex-nav-installer.sh -N 4`
- -i or --ip

     Specify the IPv4 or IPv6 IP address to bind to the node. If left blank and -N = 4 then the main WAN IPv4 address will be used. If left blank and -N = 6 then a new IPv6 address will be registered

     Usage Example: `sudo sh nullex-nav-installer.sh -i 46.5.102.49`
- -p or --port

     Specify the port # that the wallet should listen on. If left blank the value will be auto-selected
     
     Usage Example: `sudo sh nullex-nav-installer.sh -p 4559`
- -n or --number

     The node install #. Default install # is 1. Increment this value to set up 2+ nodes. **Only a single wallet will be installed each time the script is run**. Valid inputs are 1-99
     
     Usage Example: `sudo sh nullex-nav-installer.sh -n 2`
- -s or --noswap

     Skip creating the disk swap file. The swap file only needs to be created once per computer. It is strongly recommended that you do not skip this install unless you are sure your VPS has enough memory
     
     Usage Example: `sudo sh nullex-nav-installer.sh -s`
- -f or --nofirewall

     Skip the firewall setup. It is strongly recommended that you do not skip this install unless you plan to do the firewall setup manually
     
     Usage Example: `sudo sh nullex-nav-installer.sh -f`
- -b or --nobruteprotect

     Skip the brute-force protection setup. Brute-force protection only needs to be installed once per computer
     
     Usage Example: `sudo sh nullex-nav-installer.sh -b`
- -c or --nochainsync

     Skip waiting for the blockchain to sync after installation. Default is to wait for the blockchain to fully sync before exiting. Only works when the block explorer web address can be reached
     
     Usage Example: `sudo sh nullex-nav-installer.sh -c`

## Recomended Installation Instructions

To begin, you must first download the initial script and give it execute permission with the following 2 commands:

`wget https://raw.githubusercontent.com/NLXionaire/nullex-nav-installer/master/nullex-nav-installer.sh`

`sudo chmod +x nullex-nav-installer.sh`

#### Install 1st/default wallet using IPv6:

```
sudo sh nullex-nav-installer.sh
```

#### Install 1st/default wallet using the default IPv4 address:

```
sudo sh nullex-nav-installer.sh -N 4
```

#### Install 2nd wallet using IPv6 (not required, but also skip the disk swap file setup and brute-force protection setup since those only need to be installed once):

```
sudo sh nullex-nav-installer.sh -n 2 -s -b
```

#### Install 2nd wallet using IPv4 (a 2nd ip address needs to be specified if you have purchased more than 1 IPv4 ip address) (not required, but also skip the disk swap file setup and brute-force protection setup since those only need to be installed once):

```
sudo sh nullex-nav-installer.sh -n 2 -N 4 -i 45.32.168.34 -s -b
```

**NOTE:** Installing the 3rd, 4th, 5th, etc wallets are identical to the 2nd wallet except that you would change the -n value to 3, 4, 5, etc

```
sudo sh nullex-nav-installer.sh -n 3 -s -b
sudo sh nullex-nav-installer.sh -n 4 -s -b
sudo sh nullex-nav-installer.sh -n 5 -s -b
```

**NOTE:** If you are installing multiple wallets, they do not need to be installed in any specific order although it is generally easier to install in numerical sequence (install 1 then 2 then 3, etc).

## Update Instructions

At any point after the initial installation you can "refresh" a particular wallet install by re-running the following command:

`sudo sh nullex-nav-installer.sh`

This will "remember" all of your previously installed settings and allow you to update the installed wallet to the latest version (assuming a new version has been released since the last update/install).

If you would like to keep your wallet installed but just change one of the options, such as ip address type, you could update install using something like this:

`sudo sh nullex-nav-installer.sh -N 4`

This would allow you to change an IPv6 installed wallet into an IPv4 wallet. **NOTE:** Changing options like this will most likely require you to reconfigure your cold wallet NulleX.conf and masternode.conf files. The 'Final setup instructions' are always displayed at the end of an update install the same way as they are for the initial install.

## Uninstallation Instructions

#### Uninstall 1st/default wallet:

```
sudo sh nullex-nav-installer.sh -t u
```

#### Uninstall 2nd wallet:

```
sudo sh nullex-nav-installer.sh -t u -n 2
```

#### Uninstall 3rd, 4th, 5th wallet:

```
sudo sh nullex-nav-installer.sh -t u -n 3
sudo sh nullex-nav-installer.sh -t u -n 4
sudo sh nullex-nav-installer.sh -t u -n 5
```

**NOTE:** You can uninstall any wallet at any time. They do not need to be uninstalled in any specific order.

## Useful Commands

**NOTE:** To manually run commands (such as starting the wallet or running the '`stop`' or '`masternode status`' commands) on one of the 2+ installs you must reference the correct data directory.

#### Stop the 1st/default wallet:

```
nullex-cli stop
```

#### Stop the 2nd wallet:

```
nullex-cli2 -datadir=$HOME/.nullexqt2 stop
```

#### Stop the 3rd, 4th, 5th wallet:

```
nullex-cli3 -datadir=$HOME/.nullexqt3 stop
nullex-cli4 -datadir=$HOME/.nullexqt4 stop
nullex-cli5 -datadir=$HOME/.nullexqt5 stop
```

#### Start the 1st/default wallet:

```
nullexd
```

#### Start the 2nd wallet:

```
nullexd2 -datadir=$HOME/.nullexqt2
```

#### Start the 3rd, 4th, 5th wallet:

```
nullexd3 -datadir=$HOME/.nullexqt3 -daemon
nullexd4 -datadir=$HOME/.nullexqt4 -daemon
nullexd5 -datadir=$HOME/.nullexqt5 -daemon
```

#### View the 1st/default wallets current block:

```
nullex-cli getblockcount
```

#### View the 2nd wallets current block:

```
nullex-cli2 -datadir=$HOME/.nullexqt2 getblockcount
```

#### View the 3rd, 4th, 5th wallets current block:

```
nullex-cli3 -datadir=$HOME/.nullexqt3 getblockcount
nullex-cli4 -datadir=$HOME/.nullexqt4 getblockcount
nullex-cli5 -datadir=$HOME/.nullexqt5 getblockcount
```

#### Check masternode status for the 1st/default wallet:

```
nullex-cli masternode status
```

#### Check masternode status for the 2nd wallet:

```
nullex-cli2 -datadir=$HOME/.nullexqt2 masternode status
```

#### Check masternode status for the 3rd, 4th, 5th wallets:

```
nullex-cli3 -datadir=$HOME/.nullexqt3 masternode status
nullex-cli4 -datadir=$HOME/.nullexqt4 masternode status
nullex-cli5 -datadir=$HOME/.nullexqt5 masternode status
```

## Donate

```
NLX: AGyvdmGojLFbFpqM7XCSwzWM7zanX5Tbwx
BTC: 1NpuD7EiFULUC944RvEd2AMJ6Xj13W1e7g
```