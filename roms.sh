#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 06/12/2020
#Last Modified: 08/21/2020
clear
IFS=$'\n'
ex ()
{
  for archive in *; do
    case $archive in
      *.tar.bz2)   tar xjf $archive   ;;
      *.tar.gz)    tar xzf $archive   ;;
      *.bz2)       bunzip2 $archive   ;;
      *.rar)       unrar x $archive   ;;
      *.gz)        gunzip $archive    ;;
      *.tar)       tar xf $archive    ;;
      *.tbz2)      tar xjf $archive   ;;
      *.tgz)       tar xzf $archive   ;;
      *.zip)       unzip $archive     ;;
      *.Z)         uncompress $archive;;
      *.7z)        7z x $archive      ;;
      *)           echo "'$archive' cannot be extracted via ex()" ;;
    esac
  done
}


NES () {
cd $HOME/Downloads/NES
sudo mv -v *.zip /run/media/david/SHARE/roms/nes
clear
}

SNES () {
cd $HOME/Downloads/SNES
sudo mv -v *.zip /run/media/david/SHARE/roms/snes
clear
}

PSX () {
cd $HOME/Downloads/PSX
sudo mv -v *.iso *.bin *.7z *.zip /run/media/david/SHARE/roms/psx
clear
}

PSP () {
cd $HOME/Downloads/PSP
ex
sudo mv -v *.iso /run/media/david/SHARE/roms/psp
rm -iv *.7z *.txt
clear
}

NDS () {
cd $HOME/Downloads/NDS
sudo mv -v *.zip /run/media/david/SHARE/roms/nds
clear
}

DC () {
cd $HOME/Downloads/DC
ex
sudo mv -v *.bin *.cdi *.gdi *.chd *.zip *.raw  /run/media/david/SHARE/roms/dreamcast
rm -iv *.7z *.txt *.cue
clear
}

N64 () {
cd $HOME/Downloads/N64
sudo mv -v *.z64 *.n64 *.v64 *.zip *.7z /run/media/david/SHARE/roms/n64
clear
}

GC () {
cd $HOME/Downloads/GC
ex
sudo mv -v *.gcm *.iso *.gcz *.ciso *.wbfs /run/media/david/SHARE/roms/gamecube
rm -iv *.7z *.txt
clear
}

PS2 () {
cd $HOME/Downloads/PS2
ex
sudo mv -v *.iso *.bin *.cue /run/media/david/SHARE/roms/ps2
rm -iv *.7z *.txt
clear
}

while true; do
echo "What type of roms are you moving?"
echo
echo "1) NES"
echo "2) SNES"
echo "3) PSX"
echo "4) PSP"
echo "5) NDS"
echo "6) DC"
echo "7) N64"
echo "8) GC"
echo "9) PS2"
read -p "#?" INPUT
clear
case $INPUT in
1) NES;;
2) SNES;;
3) PSX;;
4) PSP;;
5) NDS;;
6) DC;;
7) N64;;
8) GC;;
9) PS2;;
*) echo "Nope!" ; sleep 3
clear;;
esac
done


