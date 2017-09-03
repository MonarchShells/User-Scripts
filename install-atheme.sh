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
						echo "Installs Atheme into ~/services/atheme"
						;;
					remove)
						echo "Removes Atheme"
						;;
					help)
						echo "You obviously know how the help function works"
						;;
				esac
				;;
			install)
				echo "I'm running as $USER on $HOSTNAME"
				echo "Will install Atheme to $HOME/services/atheme"
				echo "Erasing old temporary directory"
				rm -rf $TMPDIR/$USER
				echo "Creating directory $HOME/services"
				mkdir -p $HOME/services
				echo "Erasing old versions of Atheme"
				rm -rf $HOME/services/atheme
				echo "Creating Atheme directory"
				mkdir -p $HOME/services/atheme
				echo "Creating temporary directory(s)"
				mkdir -p $TMPDIR/$USER/src
				cd $TMPDIR/$USER/src
				wget -q https://github.com/atheme/atheme/releases/download/v7.2.9/atheme-7.2.9.tar.bz2
				if [ ! -f "atheme-7.2.9.tar.bz2" ]
				then
					echo "Download failed, dropping you back to your shell"
					cd $HOME
					rm -rf $TMPDIR/$USER
					exit
				else
					tar xf atheme-7.2.9.tar.bz2
					cd atheme-*
					./configure --prefix=$HOME/services/atheme
					make -j$(nproc)
					make install
				fi
				echo "All done, cleaning up"
				echo "Atheme is now installed! You can find it in $HOME/services/atheme"
				cd $HOME
				rm -rf $TMPDIR/$USER
				exit
				;;
			remove)
				echo "Removing Atheme"
				rm -rf $HOME/services/atheme
				echo "All done"
				exit
				;;
			*)
				echo "Usage: $0 {install|remove|help <command>}"
				exit
				;;
esac
