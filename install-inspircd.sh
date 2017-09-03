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
						echo "Installs InspIRCd into ~/ircd/inspircd"
						;;
					remove)
						echo "Removes InspIRCd"
						;;
					help)
						echo "You obviously know how the help function works"
						;;
				esac
				;;
			install)
				echo "I'm running as $USER on $HOSTNAME"
				echo "Will install InspIRCd to $HOME/ircd/inspircd"
				echo "Erasing old temporary directory"
				rm -rf $TMPDIR/$USER
				echo "Creating directory $HOME/ircd"
				mkdir -p $HOME/ircd
				echo "Erasing old versions of InspIRCd"
				rm -rf $HOME/ircd/inspircd
				echo "Creating InspIRCd directory"
				mkdir -p $HOME/ircd/inspircd
				echo "Creating temporary directory(s)"
				mkdir -p $TMPDIR/$USER/src
				cd $TMPDIR/$USER/src
				wget -q https://github.com/inspircd/inspircd/archive/v2.0.24.tar.gz
				if [ ! -f "v2.0.24.tar.gz" ]
				then
					echo "Download failed, dropping you back to your shell"
					cd $HOME
					rm -rf $TMPDIR/$USER
					exit
				else
					tar xf v2.0.24.tar.gz
					cd inspircd-*
					./configure --enable-extras=m_ssl_gnutls.cpp
					./configure ./configure --enable-gnutls --enable-epoll --prefix=$HOME/ircd/inspircd --config-dir=$HOME/ircd/inspircd/conf --log-dir=$HOME/ircd/inspircd/logs --data-dir=$HOME/ircd/inspircd/data --module-dir=$HOME/ircd/inspircd/modules --binary-dir=$HOME/ircd/inspircd/bin
					make -j$(nproc)
					make install
				fi
				echo "All done, cleaning up"
				echo "InspIRCd is now installed! You can find it in $HOME/ircd/inspircd"
				cd $HOME
				rm -rf $TMPDIR/$USER
				exit
				;;
			remove)
				echo "Removing InspIRCd"
				rm -rf $HOME/ircd/inspircd
				echo "All done"
				exit
				;;
			*)
				echo "Usage: $0 {install|remove|help <command>}"
				exit
				;;
esac
