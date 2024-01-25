#!/data/data/com.termux/files/usr/bin/bash
#colors
White="$(printf '\033[1;1m')"
Red="$(printf '\033[1;31m')"
Blue="$(printf '\033[1;34m')"
Green="$(printf '\033[1;32m')"
Yellow="$(printf '\033[1;33m')"
Cyan="$(printf '\033[1;36m')"

#Getting CPU Architecture
ARCHITECTURE=$(dpkg --print-architecture)

#Banner
echo ${Blue}"
    _   __  __  __  _____      ____    __      ____    ______
   / | / / / / / / /__  /     / __ \  / /     / __ \  /_   _/
  /  |/ / / /_/ /    / /     / /_/ / / /     / / / /   / /
 / /|  / / __  /    / /___  / ____/ / /___  / /_/ / _ / /_
/_/ |_/ /_/ /_/    /_____/ /_/     /____ / /_____/ /_____/
"
echo ${Green} "           (NHZ-PROOT-LINUX-DISTRO-INSTALLER)"
echo ${Red}"                  Author: Nick Codings"
sleep 1
echo ${Cyan}"
This script is made by NHZ/Nick-Codings
"
sleep 0.5
echo ${Red}"Warning!"
sleep 0.3
echo ${Red}"Error may occur during installation!"
sleep 0.5
echo ""
echo ${Green}"Please try to re-run the script"
sleep 0.5
echo""

#Installimg requirements
echo ${Blue}"Installing Requirements"
sleep 0.5
echo""
echo ${Cyan}"Installing proot"
echo
    apt update
    apt install proot -y
echo ""
echo ${Cyan}"Installing pulse-audio"
echo
    apt update
    apt install pulseaudio -y
echo""
echo ${Cyan}"Installing wget"
echo
    apt update
    apt install wget -y
echo " "
echo ${Cyan}"Installing Tar"
echo
    apt update
    apt install tar
cd
if [ ! -d "storage" ]; then
        echo ${G}"Please allow storage permissions"
        termux-setup-storage
        clear
fi

#Notice
case `dpkg --print-architecture` in
    aarch64)
            arch="arm64" ;;
    arm*)
            arch="armhf" ;;
    ppc64el)
            arch="ppc64el" ;;
    x86_64)
            arch="amd64" ;;
    *)
            echo "Unknown architecture"; exit 1 ;;
esac

echo ${Blue}"Your CPU architecture is $ARCHITECTURE/$arch"
sleep 0.5
echo ""
echo ${Blue}"Please Find the rootfs link of the Linux Distro
you want to install"
sleep 0.5
echo ""
echo ${Green}"Example: Ubuntu 23.10 rootfs link
https://cloud-images.ubuntu.com/releases/23.10/release/ubuntu-23.10-server-cloudimg-arm64-root.tar.xz

ROOT FILE SYSTEM LINK FOR UBUNTU 23.10 ^^"
sleep 0.5
echo ""
echo ${Cyan}"Press Enter If Done, Finding the ROOTFS Link to continue <3" ${White}
read enter
sleep 2
clear

#Link

echo ${Blue}"
    _   __  __  __  _____      ____    __      ____    ______
   / | / / / / / / /__  /     / __ \  / /     / __ \  /_   _/
  /  |/ / / /_/ /    / /     / /_/ / / /     / / / /   / /
 / /|  / / __  /    / /___  / ____/ / /___  / /_/ / _ / /_
/_/ |_/ /_/ /_/    /_____/ /_/     /____ / /_____/ /_____/
"
echo ${Green} "           (NHZ-PROOT-LINUX-DISTRO-INSTALLER)"
echo ${Red}"                  Author: Nick Codings"
echo ""
echo ${Cyan}"Enter the ROOTFS link:"
read LINK
sleep 1
echo ""
echo ${Blue}"Please put your distro name"
echo ${Blue}"If you put 'ubuntu', your login script will be"
echo ${Blue}"'bash ubuntu.sh' "
echo ""
sleep 0.5
echo ${Red}"Distro name?"${White}
read dm
sleep 1
echo ""
echo ${Yellow}"Your Distro Name is $dm and your login command is
'bash $dm.sh"
sleep 3 ; cd
folder=$dm-fs
if [ -d "$folder" ]; then
        echo ${Red}"Existing directory found, are you sure to remove it? (y or n)"${Green}
        read ans
        if [[ "$ans" =~ ^([yY])$ ]]; then
                echo ${Green}"Deleting existing directory...."
                rm -rf ~/$folder
                rm -rf ~/$dm.sh
                sleep 1
                if [ -d "$folder" ]; then
                        echo ${Red}"Cannot remove directory"; exit 1
                fi
        elif [[ "$ans" =~ ^([nN])$ ]]; then
                echo ${Red}"Sorry, but we cannot complete the installation"                               exit
        else
                echo ${Red}"Invalid answer"; exit 1
        fi
else
mkdir -p ~/$folder
fi

#Downloading and decompressing rootfs
clear
echo ${Blue}"Downloading $dm Root file system....."${White}
wget -q --show-progress $LINK -P ~/$folder/
if [ "$(ls ~/$folder)" == "" ]; then
    echo ${Red}"Error in downloading rootfs..."; exit 1
fi
echo ${Cyan}"Decompressing Rootfs....."${White}
proot --link2symlink \
    tar -xpf ~/$folder/*.tar.* -C ~/$folder/ --exclude='dev'
if [[ ! -d "$folder/root" ]]; then
    mv $folder/*/* $folder/
    if [[ ! -d "$folder/root" ]]; then
        echo ${Red}"Error in decompressing rootfs"; exit 1
    fi
fi

#Setting up environment
mkdir -p ~/$folder/tmp
echo "127.0.0.1 localhost" > ~/$folder/etc/hosts
rm -rf ~/$folder/etc/hostname
rm -rf ~/$folder/etc/resolv.conf
echo "localhost" > ~/$folder/etc/hostname
echo "nameserver 8.8.8.8" > ~/$folder/etc/resolv.conf
echo -e "#!/bin/sh\nexit" > ~/$folder/usr/bin/groups
mkdir -p $folder/binds
cat <<- EOF >> "$folder/etc/environment"
EXTERNAL_STORAGE=/sdcard
LANG=en_US.UTF-8
MOZ_FAKE_NO_SANDBOX=1
PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games
PULSE_SERVER=127.0.0.1
TERM=xterm-256color
TMPDIR=/tmp
EOF

#Sound Fix
echo "export PULSE_SERVER=127.0.0.1" >> $folder/root/.bashrc

##script
echo ${G}"writing launch script"
sleep 1
bin=$dm.sh
cat > $bin <<- EOM
#!/bin/bash
cd \$(dirname \$0)

## Start pulseaudio
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1

## Set login shell for different distributions
login_shell=\$(grep "^root:" "$folder/etc/passwd" | cut -d ':' -f 7)

## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD

## Proot Command
command="proot"
## uncomment following line if you are having FATAL: kernel too old message.
#command+=" -k 4.14.81"
command+=" --link2symlink"
command+=" -0"
command+=" -r $folder"
if [ -n "\$(ls -A $folder/binds)" ]; then
    for f in $folder/binds/* ;do
      . \$f
    done
fi
command+=" -b /dev"
command+=" -b /dev/null:/proc/sys/kernel/cap_last_cap"
command+=" -b /proc"
command+=" -b /dev/null:/proc/stat"
command+=" -b /sys"
command+=" -b /data/data/com.termux/files/usr/tmp:/tmp"
command+=" -b $folder/tmp:/dev/shm"
command+=" -b /data/data/com.termux"
command+=" -b /sdcard"
command+=" -b /storage"
command+=" -b /mnt"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\$TERM"
command+=" LANG=C.UTF-8"
command+=" \$login_shell"
com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOM

clear
termux-fix-shebang $bin
rm -rf $folder/*.tar.*
bash $bin "touch ~/.hushlogin ; exit"
clear
#Banner
echo ${Blue}"
    _   __  __  __  _____      ____    __      ____    ______
   / | / / / / / / /__  /     / __ \  / /     / __ \  /_   _/
  /  |/ / / /_/ /    / /     / /_/ / / /     / / / /   / /
 / /|  / / __  /    / /___  / ____/ / /___  / /_/ / _ / /_
/_/ |_/ /_/ /_/    /_____/ /_/     /____ / /_____/ /_____/
"
echo ${Green} "           (NHZ-PROOT-LINUX-DISTRO-INSTALLER)"
echo ${Red}"                  Author: Nick Codings"
sleep 1
echo ""
echo ${Red}"If you find problem/errors re-install and re-run the
script"
echo""
sleep 0.5
echo ${Blue}"You can now start your distro with '$dm.sh' script"
sleep 0.5
echo ${Cyan}"Runner Command : ${Yellow}bash $dm.sh "
echo ""
sleep 1
echo ${Green} "Running $dm....."
echo
    bash $dm.sh
