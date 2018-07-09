# NulleX NAV Installer

### Beta Release v0.9.6
#### IMPORTANT NOTE 1:
The original default/fastest method of installing a NAV wallet is by using precompiled binaries but this ability has been temporarily disabled due to the fact that official binaries have not yet been released for the linux wallet. Therefore the install process is temporarily defaulted to building the wallet from source, which takes significantly much more time and uses more hard drive space, etc. The default will be reverted back to the faster install process as soon as proper binaries can be procured.

#### IMPORTANT NOTE 2:
The script was written with the ability to install multiple NAV's in parallel on the same VPS but it was recently discovered that the open source code used in the NulleX wallet specifically does not allow this configuration. If and when a solution to this problem is discovered, this script already contains full support for running multiple NAV's on the same VPS and will "just work" if the wallets themselves can be updated to get around this problem.

## General information

A custom masternode install script made from scratch specifically for installing Nullex NAVs.

Currently, it must be run on Ubuntu Linux 16.04 and has been tested to work using VPS systems from vultr.com only but should be generic enough to run anywhere (Please let @NLXionaire know your experience in https://t.me/NullexOfficial if you have tried with another VPS provider).

Since this script has the potential to install "extra" software components such as a firewall and/or create a swap disk file, root privileges are required to install properly. Therefore, you must either run the script using the `sudo` command prefix or else run directly as the root user (generally not recommended for security reasons but still supported).

All wallets are installed to the /usr/local/bin directory.

To save time on 2+ installs, the wallet binaries are archived in the wallet directory (typically /usr/local/bin/NulleX) after the first successful install and those locally stored files are then used to install subsequent wallet installs in much less time than the first.

## Features

- Supports installing, updating or uninstalling up to 99 Nullex Nav installs on the same VPS
- IPv4 and IPv6 support
- Automatic update feature ensures you are always installing using the most up-to-date script
- Install wallet from compiled binary files or build from source code
- Faster syncing times for 2+ installs by copying previously installed blockchain files over to new installs
- Automatic restart of installed Navs after reboot
- Install additional setup components such as swap disk file, firewall configuration and brute-force protection
- Visualize the blockchain sync process after installation to ensure wallet(s) are all caught up with current block counts
- Custom ascii art Nullex logo

## Future features/Known issues

- Replace the wallet binaries with official versions
- Enable blockchain sync monitoring once an official block explorer website is made available
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

## Recomended installation instructions:

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

## Uninstallation instructions:

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

## Useful commands:

**NOTE:** To manually run commands (such as starting the wallet or running the '`stop`' or '`masternode status`' commands) on one of the 2+ installs you must reference the correct data directory.

#### Stop the 1st/default wallet:

```
/usr/local/bin/NulleX/nullex-cli stop
```

#### Stop the 2nd wallet:

```
/usr/local/bin/NulleX2/nullex-cli -datadir=$HOME/.NulleX2 stop
```

#### Stop the 3rd, 4th, 5th wallet:

```
/usr/local/bin/NulleX3/nullex-cli -datadir=$HOME/.NulleX3 stop
/usr/local/bin/NulleX4/nullex-cli -datadir=$HOME/.NulleX4 stop
/usr/local/bin/NulleX5/nullex-cli -datadir=$HOME/.NulleX5 stop
```

#### Start the 1st/default wallet:

```
/usr/local/bin/NulleX/nullexd -daemon
```

#### Start the 2nd wallet:

```
/usr/local/bin/NulleX2/nullexd -datadir=$HOME/.NulleX2 -daemon
```

#### Start the 3rd, 4th, 5th wallet:

```
/usr/local/bin/NulleX3/nullexd -datadir=$HOME/.NulleX3 -daemon
/usr/local/bin/NulleX4/nullexd -datadir=$HOME/.NulleX4 -daemon
/usr/local/bin/NulleX5/nullexd -datadir=$HOME/.NulleX5 -daemon
```
