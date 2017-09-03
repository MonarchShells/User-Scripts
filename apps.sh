#!/bin/bash
#
# Copyright (C) 2Pro International Limited - All Rights Reserved
# Unauthorized copying of this file, via any medium is strictly prohibited
# If you wish to use these scripts for yourself, please contact the author
# Written by Theo Morra <theo@2pro.international>, September 2017
#
case "$1" in
			help)
				case "$2" in
					install)
						echo "Installs a package"
						;;
					remove)
						echo "Removes a package"
						;;
          list)
						echo "Lists available packages"
						;;
					help)
						echo "You obviously know how the help function works"
						;;
				esac
				;;
			install)
          case "$2" in
            anope)
              /var/xpro/apps/install-anope.sh install
              ;;
            atheme)
              /var/xpro/apps/install-atheme.sh install
              ;;
            charybdis)
              /var/xpro/apps/install-charybdis.sh install
              ;;
            eggdrop)
              /var/xpro/apps/install-eggdrop.sh install
              ;;
            inspircd)
              /var/xpro/apps/install-inspircd.sh install
              ;;
            limnoria)
              /var/xpro/apps/install-limnoria.sh install
              ;;
            unreal)
              /var/xpro/apps/install-unreal.sh install
              ;;
            znc)
              /var/xpro/apps/install-znc.sh install
              ;;
            *)
              echo "Available packages: anope, atheme, charybdis, eggdrop, inspircd, limnoria, unreal, znc"
              exit
              ;;
          esac
				;;
			remove)
				case "$2" in
          anope)
            /var/xpro/apps/install-anope.sh remove
            ;;
          atheme)
            /var/xpro/apps/install-atheme.sh remove
            ;;
          charybdis)
            /var/xpro/apps/install-charybdis.sh remove
            ;;
          eggdrop)
            /var/xpro/apps/install-eggdrop.sh remove
            ;;
          inspircd)
            /var/xpro/apps/install-inspircd.sh remove
            ;;
          limnoria)
            /var/xpro/apps/install-limnoria.sh remove
            ;;
          unreal)
            /var/xpro/apps/install-unreal.sh remove
            ;;
          znc)
            /var/xpro/apps/install-znc.sh remove
            ;;
          *)
            echo "Available packages: anope, atheme, charybdis, eggdrop, inspircd, limnoria, unreal, znc"
            exit
            ;;
        esac
				;;
      list)
        echo "Available packages: anope, atheme, charybdis, eggdrop, inspircd, limnoria, unreal, znc"
        exit
        ;;
			*)
				echo "Usage: $0 {install <package>|remove <package>|help <command>|list}"
				exit
				;;
esac
