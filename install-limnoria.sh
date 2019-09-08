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
						echo "Installs Limnoria into ~/bots/limnoria"
						;;
					remove)
						echo "Removes Limnoria"
						;;
					help)
						echo "You obviously know how the help function works"
						;;
				esac
				;;
			install)
				echo "I'm running as $USER on $HOSTNAME"
				echo "Will install Limnoria to $HOME/bots/limnoria"
				echo "Erasing old temporary directory"
				rm -rf $TMPDIR/$USER
				echo "Creating directory $HOME/bots"
				mkdir -p $HOME/bots
				echo "Erasing old versions of Limnoria"
				rm -rf $HOME/bots/limnoria
				pip uninstall -r https://raw.githubusercontent.com/ProgVal/Limnoria/master/requirements.txt -y
				pip uninstall limnoria -y
				echo "Creating Limnoria directory"
				mkdir -p $HOME/bots/limnoria
				echo "Creating temporary directory(s)"
				mkdir -p $TMPDIR/$USER/src/limnoria
				chmod -R 0700 $TMPDIR/$USER
				cd $TMPDIR/$USER/src
				echo "Installing dependencies for Limnoria"
				pip install -r https://raw.githubusercontent.com/ProgVal/Limnoria/master/requirements.txt --user --upgrade
				echo "Installing Limnoria"
				pip install limnoria --user --upgrade
				echo 'PATH="$HOME/.local/bin:$PATH"' >> ~/.$(echo $SHELL|cut -d/ -f3)rc
				source ~/.$(echo $SHELL|cut -d/ -f3)rc
				echo "Running Limnoria wizard"
				cd $HOME/bots/limnoria
				supybot-wizard
				echo "All done, cleaning up"
				echo "Limnoria is now installed! You can find it in $HOME/bots/limnoria"
				cd $HOME
				rm -rf $TMPDIR/$USER
				exit
				;;
			remove)
				echo "Removing Limnoria"
				rm -rf $HOME/bots/limnoria
				pip uninstall -r https://raw.githubusercontent.com/ProgVal/Limnoria/master/requirements.txt -y
				pip uninstall limnoria -y
				echo "All done"
				exit
				;;
			*)
				echo "Usage: $0 {install|remove|help <command>}"
				exit
				;;
esac
