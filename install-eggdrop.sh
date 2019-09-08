#!/bin/bash
#
# Copyright (C) Monarch Solutions - All Rights Reserved
# Unauthorized copying of this file, via any medium is strictly prohibited
# If you wish to use these scripts for yourself, please contact the author
# Written by Theo Morra <https://github.com/td512>, September 2017
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
						echo "Installs Eggdrop into ~/bots/eggdrop"
						;;
					remove)
						echo "Removes eggdrop"
						;;
					help)
						echo "You obviously know how the help function works"
						;;
				esac
				;;
			install)
				echo "I'm running as $USER on $HOSTNAME"
				echo "Will install Eggdrop to $HOME/bots/eggdrop"
				echo "Erasing old temporary directory"
				rm -rf $TMPDIR/$USER
				echo "Creating directory $HOME/bots"
				mkdir -p $HOME/bots
				echo "Erasing old versions of eggdrop"
				rm -rf $HOME/bots/eggdrop
				echo "Creating temporary directory(s)"
				mkdir -p $TMPDIR/$USER/src
				chmod -R 0700 $TMPDIR/$USER
				cd $TMPDIR/$USER/src
				echo "Downloading Eggdrop 1.8"
				wget -q ftp://ftp.eggheads.org/pub/eggdrop/source/eggdrop1.8-latest.tar.gz
				if [ ! -f "eggdrop1.8-latest.tar.gz" ]
				then
					echo "Download failed, dropping you back to your shell"
					cd $HOME
					rm -rf $TMPDIR/$USER
					exit
				else
					tar xf eggdrop1.8-latest.tar.gz
					cd eggdrop-1.8*
					./configure
					make config -j2
					make -j$2
					make install DEST=$HOME/bots/eggdrop
					echo "All done, cleaning up"
					echo "Eggdrop is now installed! You can find it in $HOME/bots/eggdrop"
					cd $HOME
					rm -rf $TMPDIR/$USER
					exit
				fi
				;;
			remove)
				echo "Removing Eggdrop"
				rm -rf $HOME/bots/eggdrop
				echo "All done"
				exit
				;;
			*)
				echo "Usage: $0 {install|remove|help <command>}"
				exit
				;;
esac
