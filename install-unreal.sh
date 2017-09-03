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
						echo "Installs UnrealIRCd into ~/ircd/unreal"
						;;
					remove)
						echo "Removes UnrealIRCd"
						;;
					help)
						echo "You obviously know how the help function works"
						;;
				esac
				;;
			install)
				echo "I'm running as $USER on $HOSTNAME"
				echo "Will install UnrealIRCd to $HOME/ircd/unreal"
				echo "Erasing old temporary directory"
				rm -rf $TMPDIR/$USER
				echo "Creating directory $HOME/ircd"
				mkdir -p $HOME/ircd
				echo "Erasing old versions of UnrealIRCd"
				rm -rf $HOME/ircd/unreal
				echo "Creating UnrealIRCd directory"
				mkdir -p $HOME/ircd/unreal
				echo "Creating temporary directory(s)"
				mkdir -p $TMPDIR/$USER/src
				cd $TMPDIR/$USER/src
				wget -q --no-check-certificate https://www.unrealircd.org/downloads/unrealircd-latest.tar.gz
				if [ ! -f "unrealircd-latest.tar.gz" ]
				then
					echo "Download failed, dropping you back to your shell"
					cd $HOME
					rm -rf $TMPDIR/$USER
					exit
				else
					tar xf unrealircd-latest.tar.gz
					cd unrealircd-*
					cat <<EOD >>config.settings
					BASEPATH="$HOME/ircd/unreal"
					BINDIR="$HOME/ircd/unreal/bin"
					DATADIR="$HOME/ircd/unreal/data"
					CONFDIR="$HOME/ircd/unreal/conf"
					MODULESDIR="$HOME/ircd/unreal/modules"
					LOGDIR="$HOME/ircd/unreal/logs"
					CACHEDIR="$HOME/ircd/unreal/cache"
					DOCDIR="$HOME/ircd/unreal/doc"
					TMPDIR="$HOME/ircd/unreal/tmp"
					LIBDIR="$HOME/ircd/unreal/lib"
					PREFIXAQ="1"
					MAXSENDQLENGTH="3000000"
					MAXCONNECTIONS="1024"
					NICKNAMEHISTORYLENGTH="2000"
					DEFPERM="0600"
					SSLDIR=""
					REMOTEINC=""
					CURLDIR=""
					SHOWLISTMODES="1"
					TOPICNICKISNUH=""
					SHUNNOTICES=""
					NOOPEROVERRIDE=""
					DISABLEUSERMOD=""
					OPEROVERRIDEVERIFY=""
					DISABLEEXTBANSTACKING=""
					GENCERTIFICATE="1"
					EXTRAPARA=""
					ADVANCED=""
EOD
					./Config -quick
					make -j$(nproc)
					make install
				fi
				echo "All done, cleaning up"
				echo "UnrealIRCd is now installed! You can find it in $HOME/ircd/unreal"
				cd $HOME
				rm -rf $TMPDIR/$USER
				exit
				;;
			remove)
				echo "Removing UnrealIRCd"
				rm -rf $HOME/ircd/unreal
				echo "All done"
				exit
				;;
			*)
				echo "Usage: $0 {install|remove|help <command>}"
				exit
				;;
esac
