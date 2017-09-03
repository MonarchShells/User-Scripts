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
						echo "Installs Anope into ~/services/anope"
						;;
					remove)
						echo "Removes Anope"
						;;
					help)
						echo "You obviously know how the help function works"
						;;
				esac
				;;
			install)
				echo "I'm running as $USER on $HOSTNAME"
				echo "Will install Anope to $HOME/services/anope"
				echo "Erasing old temporary directory"
				rm -rf $TMPDIR/$USER
				echo "Creating directory $HOME/services"
				mkdir -p $HOME/services
				echo "Erasing old versions of Anope"
				rm -rf $HOME/services/anope
				echo "Creating Anope directory"
				mkdir -p $HOME/services/anope
				echo "Creating temporary directory(s)"
				mkdir -p $TMPDIR/$USER/src
				cd $TMPDIR/$USER/src
				wget -q https://github.com/anope/anope/releases/download/2.0.5/anope-2.0.5-source.tar.gz
				if [ ! -f "anope-2.0.5-source.tar.gz" ]
				then
					echo "Download failed, dropping you back to your shell"
					cd $HOME
					rm -rf $TMPDIR/$USER
					exit
				else
					tar xf anope-2.0.5-source.tar.gz
					cd anope-*
					echo "INSTDIR=\"$HOME/services/anope\"" >>config.cache
					echo "RUNGROUP=\"\"" >>config.cache
					echo "UMASK=077" >>config.cache
					echo "DEBUG=\"no\"" >>config.cache
					echo "USE_PCH=\"no\"" >>config.cache
					echo "EXTRA_INCLUDE_DIRS=\"\"" >>config.cache
					echo "EXTRA_LIB_DIRS=\"\"" >>config.cache
					echo "EXTRA_CONFIG_ARGS=\"\"" >>config.cache
					./Config -quick
				fi
				echo "All done, cleaning up"
				echo "Anope is now installed! You can find it in $HOME/services/anope"
				cd $HOME
				rm -rf $TMPDIR/$USER
				exit
				;;
			remove)
				echo "Removing Anope"
				rm -rf $HOME/services/anope
				echo "All done"
				exit
				;;
			*)
				echo "Usage: $0 {install|remove|help <command>}"
				exit
				;;
esac
