# NHZ-PROOT-LINUX-DISTRO-INSTALLER

# Install Linux Distributions in Termux Effortlessly!

This Bash script empowers you to install various Linux distributions within Termux, running them seamlessly on your Android device without requiring root access. Leveraging PRoot, it automates the process of downloading, configuring, and launching distros, offering a convenient way to expand your mobile capabilities.

## Key Features

- # Automated Installation:

Effortlessly handles the download and setup of rootfs files for supported distros.

- # Architecture Awareness:
Detects your device's architecture and ensures compatibility.

- # Proot Integration:
Utilizes PRoot to create isolated Linux environments without system-level modifications.

- # User-Friendly Interface:
Guides you through the installation process with clear prompts and informative messages.

- # Customizable Login Scripts:
Generates easy-to-use scripts for launching installed distros.

## Installation

1. Prerequisites:
   - Ensure you have Termux Latest Version installed on your Android device.

   - Grant Termux storage permissions if prompted.

 2. Install requirements
```bash
 apt update
 apt upgrade
 apt update
 apt install git
```

3. Clone the Repository:
```bash

git clone https://github.com/nick-codings/NHZ-PROOT-LINUX-DISTRO-INSTALLER

 ```

4. Run the Script:
```bash

cd NHZ-PROOT-LINUX-DISTRO-INSTALLER

bash nhz-proot-linux-distro-installer.sh
```

## Usage

 1. Provide Rootfs Link:
When prompted, enter the rootfs link for the distro you wish to install.

 2. Specify Distro Name:
Choose a name for your distro (used for the login script).

 3. Follow Prompts:
The script will handle the rest, providing feedback along the way.

## Launching the Distro

```bash
bash #distro name
```

- ## Acknowledgments:
Termux, Github, Ubuntu

## Enjoy Your Linux Distro On Your Termux!

- Let's explore the possibilities of Linux distribution within Termux proot

# Have a great time using linux on your android phone via Termux
