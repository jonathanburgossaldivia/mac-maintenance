#!/bin/bash
# Shell script by Jonathan Burgos
# Github: https://github.com/jonathanburgossaldivia/mac-maintenance
# FeedBack to: jonathaburgoss@outlook.com

clear

echo -e "Script for full macOS maintenance:\nDisable SIP if they require more in-depth maintenance,\nthis will allow removing protected caches,\notherwise maintenance will be a little less efficient."
echo  -e "\n<Put your user Password for continue, Ctrl + C for quit>"
sudo echo "Beggining:" || exit 1

alpha ()
{
  echo -ne  "  Memory Purge\r"
  sudo purge
}

beta ()
{
  echo -ne  "  Deleting dns cache\r"
  sudo killall -HUP mDNSResponder 2> /dev/null
}

gamma ()
{
  echo -ne  "  Deleting caches and logs from system\r"
  sudo rm -rf ~/Library/Caches/* 2> /dev/null
  sudo rm -rf /Library/Caches/* 2> /dev/null
  sudo rm -rf /System/Library/Caches/* 2> /dev/null
  sudo rm -rf /Library/Logs/* 2> /dev/null
  sudo launchctl stop com.apple.syslogd 2> /dev/null
  sudo launchctl stop com.apple.aslmanager 2> /dev/null
  sudo rm -rf "/Users/$USER/Library/Logs/*" 2> /dev/null
  sudo launchctl start com.apple.syslogd 2> /dev/null
  sudo launchctl start com.apple.aslmanager 2> /dev/null
}

delta ()
{
  echo -ne  "  Deleting App Store caches\r"
  sudo rm -rf "/Users/$USER/Library/Caches/com.apple.appstore/*" 2> /dev/null
  sudo find /private/var/folders -name com.apple.appstore -exec rm -rf {} \; 2> /dev/null
}

epsilon ()
{
  echo -ne  "  Deleting icons caches\r"
  sudo find /private/var/folders -name com.apple.iconservices -exec rm -rf {} \; 2> /dev/null
  sudo find /private/var/folders -name com.apple.dock.iconcache -exec rm -rf {} \; 2> /dev/null
}

varepsilon ()
{
  echo -ne  "  Deleting Safari caches \r"
  sudo rm -rf "/Users/$USER/Library/Caches/com.apple.Safari/*" 2> /dev/null
}

zeta ()
{
  echo -ne  "  Rebuilding Kexts caches\r"
  sudo rm -rf /System/Library/Caches/com.apple.kext.caches 2> /dev/null
  # sudo touch /System/Library/Extensions 2> /dev/null
  # sudo kextcache -system-caches 2> /dev/null
  sudo nvram -c 2> /dev/null
  # sudo update_dyld_shared_cache 2> /dev/null
}

eta ()
{
  echo -ne  "  Rebuilding CloudKit metadata\r"
  sudo rm ~/Library/Caches/CloudKit/CloudKitMetadata* 2> /dev/null
  sudo killall cloudd 2> /dev/null
}

theta ()
{
  echo -ne  "  Running maintenance scripts\r"
  sudo periodic daily weekly monthly
}

vartheta ()
{
  echo -ne  "  Deleting DS_Store hidden files\r"
  sudo find ~ \( -type d -path "*.*" -prune -o -type d -path "*/Library" -prune \) -type f -o -name ".DS_Store" \! -type d -exec rm -rf '{}' \;
}

iota ()
{
  echo -ne  "  Rebuilding correct HOME languages\r"
  touch "/Users/$USER/.localized" 2> /dev/null
  touch "/Users/$USER/Desktop/.localized" 2> /dev/null
  touch "/Users/$USER/Documents/.localized" 2> /dev/null
  touch "/Users/$USER/Downloads/.localized" 2> /dev/null
  touch "/Users/$USER/Movies/.localized" 2> /dev/null
  touch "/Users/$USER/Music/.localized" 2> /dev/null
  touch "/Users/$USER/Pictures/.localized" 2> /dev/null
  touch "/Users/$USER/Public/.localized" 2> /dev/null
  touch "/Users/$USER/Sites/.localized" 2> /dev/null
  mkdir "/Users/$USER/Public/" 2> /dev/null
  touch "/Users/$USER/Public/.localized" 2> /dev/null
  mkdir "/Users/$USER/Sites/" 2> /dev/null
  touch "/Users/$USER/Sites/.localized" 2> /dev/null
}

kappa ()
{
  echo -ne  "  Deleting windowserver files \r"
  sudo rm -rf /Library/Preferences/com.apple.windowserver.plist 2> /dev/null
  sudo rm -rf "/Users/$USER/Library/Preferences/ByHost/com.apple.windowserver*.plist" 2> /dev/null
}

lambda ()
{
  echo -ne  "  Rebuilding SpotLight metadata\r"
  sudo mdutil -E / >/dev/null
}

for maintenance in alpha beta gamma delta epsilon varepsilon zeta eta theta vartheta iota kappa lambda
do
  spin[0]='|'
  spin[1]='/'
  spin[2]='-'
  spin[3]='\'
  $maintenance &
  pid=$!
  trap kill $pid 2> /dev/null EXIT
  while kill -0 $pid 2> /dev/null
  do
    for i in "${spin[@]}"
    do
      echo -ne "$i \r"
      sleep .2
    done
    echo -ne "  Processing a task, wait \033[0K\r"
  done
  trap - EXIT
done
echo -ne "\033[0K\r"
printf "\n"
echo "Tasks have been completed"
echo "Now restart the computer and restart PRAM: Option + Command + P + R "
echo -e "After restart, while the cache is rebuilt correctly your system will use its cpu resources in these tasks,\nonly wait a few minutes, dont turn off your Mac. \n\n"
