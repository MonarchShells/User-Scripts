#!/bin/bash
#
# Copyright (C) 2Pro International Limited - All Rights Reserved
# Unauthorized copying of this file, via any medium is strictly prohibited
# If you wish to use these scripts for yourself, please contact the author
# Written by Theo Morra <theo@2pro.international>, September 2017
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
						echo "Installs ZNC into ~/ircd/znc"
						;;
					remove)
						echo "Removes ZNC"
						;;
					help)
						echo "You obviously know how the help function works"
						;;
				esac
				;;
			install)
				echo "I'm running as $USER on $HOSTNAME"
				echo "Will install ZNC to $HOME/ircd/znc"
				echo "Erasing old temporary directory"
				rm -rf $TMPDIR/$USER
				echo "Creating directory $HOME/ircd"
				mkdir -p $HOME/ircd
				echo "Erasing old versions of ZNC"
				rm -rf $HOME/ircd/znc
				echo "Creating ZNC directory"
				mkdir -p $HOME/ircd/znc
				echo "Creating temporary directory(s)"
				mkdir -p $TMPDIR/$USER/src
				chmod -R 0700 $TMPDIR/$USER
				cd $TMPDIR/$USER/src
				wget -q https://znc.in/releases/znc-1.6.5.tar.gz
				if [ ! -f "znc-1.6.5.tar.gz" ]
				then
					echo "Download failed, dropping you back to your shell"
					cd $HOME
					rm -rf $TMPDIR/$USER
					exit
				else
					tar xf znc-1.6.5.tar.gz
					cd znc-*
					./configure --prefix=$HOME/ircd/znc
					make -j$(nproc)
					make install
				fi
				echo "All done, cleaning up"
				echo "ZNC is now installed! You can find it in $HOME/ircd/znc"
				cd $HOME
				rm -rf $TMPDIR/$USER
				exit
				;;
			remove)
				echo "Removing ZNC"
				rm -rf $HOME/ircd/znc
				echo "All done"
				exit
				;;
			*)
				echo "Usage: $0 {install|remove|help <command>}"
				exit
				;;
esac
