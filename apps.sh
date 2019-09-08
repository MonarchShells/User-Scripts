#!/bin/bash
#
# Copyright (C) Monarch Solutions - All Rights Reserved
# Unauthorized copying of this file, via any medium is strictly prohibited
# If you wish to use these scripts for yourself, please contact the author
# Written by Theo Morra <https://github.com/td512>, September 2017
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
          deploy)
            echo "Deploys services (due to provisioning this could take up to 5 minutes)"
            ;;
				esac
				;;
			deploy)
          case "$2" in
            anope)
              /var/monarch/apps/install-anope.sh install
              ;;
            atheme)
              /var/monarch/apps/install-atheme.sh install
              ;;
            charybdis)
              /var/monarch/apps/install-charybdis.sh install
              ;;
            eggdrop)
              /var/monarch/apps/install-eggdrop.sh install
              ;;
            inspircd)
              /var/monarch/apps/install-inspircd.sh install
              ;;
            limnoria)
              /var/monarch/apps/install-limnoria.sh install
              ;;
            unreal)
              /var/monarch/apps/install-unreal.sh install
              ;;
            znc)
              /var/monarch/apps/install-znc.sh install
              ;;
            www)
              echo "I'm running as $USER on $HOSTNAME"
              echo "Will provision HTTP vHost"
              rm -rf $HOME/.www
              echo "All done, cleaning up"
              echo "DO NOT REMOVE ME" > $HOME/.www
              ;;
            *)
              echo "Available deployable packages: anope, atheme, charybdis, eggdrop, inspircd, limnoria, unreal, znc, www"
              exit
              ;;
          esac
				;;
			remove)
				case "$2" in
          anope)
            /var/monarch/apps/install-anope.sh remove
            ;;
          atheme)
            /var/monarch/apps/install-atheme.sh remove
            ;;
          charybdis)
            /var/monarch/apps/install-charybdis.sh remove
            ;;
          eggdrop)
            /var/monarch/apps/install-eggdrop.sh remove
            ;;
          inspircd)
            /var/monarch/apps/install-inspircd.sh remove
            ;;
          limnoria)
            /var/monarch/apps/install-limnoria.sh remove
            ;;
          unreal)
            /var/monarch/apps/install-unreal.sh remove
            ;;
          znc)
            /var/monarch/apps/install-znc.sh remove
            ;;
          www)
            echo "I'm running as $USER on $HOSTNAME"
				    echo "Will deprovision HTTP vHost"
            rm -rf $HOME/.www
            echo "All done, cleaning up"
            ;;
          *)
            echo "Available packages: anope, atheme, charybdis, eggdrop, inspircd, limnoria, unreal, znc, www"
            exit
            ;;
        esac
				;;
      list)
        echo "Available packages: anope, atheme, charybdis, eggdrop, inspircd, limnoria, unreal, znc, www"
        ;;
			*)
				echo "Usage: $0 {deploy <package>|remove <package>|help <command>|list}"
				;;
esac
