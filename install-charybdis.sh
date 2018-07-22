#!/bin/bash
#
# Copyright (C) Monarch Solutions - All Rights Reserved
# Unauthorized copying of this file, via any medium is strictly prohibited
# If you wish to use these scripts for yourself, please contact the author
# Written by Theo Morra <tmorra@gomonar.ch>, September 2017
#
export TMPDIR=/tmp
function ctrlc() {
	echo "Cleaning up..."
	pkill -u $USER -9 gcc
	pkill -u $USER -9 g++
	pkill -u $USER -9 clang
	pkill -u $USER -9 ld
	pkill -u $USER -9 configure
	rm -rf $TMPDIR/$USER
	echo "All done, dropping you back to your shell"
	exit
}
trap ctrlc SIGINT
case "$1" in
			help)
				case "$2" in
					install)
						echo "Installs Charybdis into ~/ircd/charybdis"
						;;
					remove)
						echo "Removes Charybdis"
						;;
					help)
						echo "You obviously know how the help function works"
						;;
				esac
				;;
			install)
				echo "I'm running as $USER on $HOSTNAME"
				echo "Will install Charybdis to $HOME/ircd/charybdis"
				echo "Erasing old temporary directory"
				rm -rf $TMPDIR/$USER
				echo "Creating directory $HOME/ircd"
				mkdir -p $HOME/ircd
				echo "Erasing old versions of Charybdis"
				rm -rf $HOME/ircd/charybdis
				echo "Creating Charybdis directory"
				mkdir -p $HOME/ircd/charybdis
				echo "Creating temporary directory(s)"
				mkdir -p $TMPDIR/$USER/src
				chmod -R 0700 $TMPDIR/$USER
				cd $TMPDIR/$USER/src
				wget -q https://github.com/charybdis-ircd/charybdis/archive/charybdis-3.5.5.tar.gz
				if [ ! -f "charybdis-3.5.5.tar.gz" ]
				then
					echo "Download failed, dropping you back to your shell"
					cd $HOME
					rm -rf $TMPDIR/$USER
					exit
				else
					tar xf charybdis-3.5.5.tar.gz
					cd charybdis-charybdis-*
					./configure --enable-openssl --enable-ipv6 --with-nicklen=20 --with-topiclen=420 --prefix=$HOME/ircd/charybdis
					make -j$(nproc)
					make install
				fi
				echo "All done, cleaning up"
				echo "Charybdis is now installed! You can find it in $HOME/ircd/charybdis"
				cd $HOME
				rm -rf $TMPDIR/$USER
				exit
				;;
			remove)
				echo "Removing Charybdis"
				rm -rf $HOME/ircd/charybdis
				echo "All done"
				exit
				;;
			*)
				echo "Usage: $0 {install|remove|help <command>}"
				exit
				;;
esac
