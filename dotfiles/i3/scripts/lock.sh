#!/bin/sh

# Grab window titles with wmctrl -l - Seperate by commas you want to skip lock screens if window is running.
#SKIP="Zoom Meeting"

## Check to See if "Zoom Meeting" is running

#ignore_titles=$(echo "${SKIP}" | tr "," "\n")
#for title in ${ignore_titles}
#  do
#    if test $(wmctrl -l | grep "${title}" 2>&1 | wc -l) -eq 1; then
#      skip_lock=true
#    fi
#done

#if [ "${skip_lock,,}" != "true" ] ; then
#  case $(date +%u) in
#  1 | 2 | 3 | 4 | 5 ) # Mon - Fri
#    echo "Stopping Timewarrior"
#    timew stop
#  ;;
#  6 | 7 ) # Sat and Sun
#    :
#  ;;
#  esac

  powerprofilesctl set power-saver
  betterlockscreen --off 10 --lock -- nofork
  powerprofilesctl set balanced

#  case $(date +%u) in
#    1 | 2 | 3 | 4 | 5 ) # Mon - Fri
#      case $(date +%H:%M) in
#          (0[6789]:*) # 6am Start
#            ~/.config/scripts/timewarrior.sh start
#          ;;
#          (1[012345678]:*) # 6pm End
#            ~/.config/scripts/timewarrior.sh start
#          ;;
#      esac
#    ;;
#    6 | 7 ) # Sat- Sun
#      :
#    ;;
#  esac
#fi
