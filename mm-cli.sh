#!/bin/bash -e
# mm-cli.sh

if [ $# -eq 0 ]; then
  echo -e 'Usage: mm-cli [command]\n'
  echo -e 'Commands:'
  echo -e '  install [path_to_mm7_game]     Instal Might and Magic VII executable and game assets.'
  echo -e '  run                            Execute mm7.exe.'
  exit 1
fi


#type {String[]}
MM7_FILES=(
  "Anims/Magic7.vid"
  "Anims/Might7.vid"
  "DATA/00 add.icons.lod"
  "DATA/00 patch.bitmaps.lod"
  "DATA/00 patch.events.lod"
  "DATA/00 patch.games.lod"
  "DATA/00 patch.icons.lod"
  "DATA/01 dragon.games.lod"
  "DATA/01 mon pal.bitmaps.lod"
  "DATA/01 tunnels.events.lod"
  "DATA/01 water.bitmaps.lwd"
  "DATA/BITMAPS.LOD"
  "DATA/d3dbitmap.hwl"
  "DATA/d3dsprite.hwl"
  "DATA/Events.lod"
  "DATA/GAMES.LOD"
  "DATA/ICONS.LOD"
  "DATA/icons.UI.lod"
  "DATA/MouseCursorShooter.bmp"
  "DATA/MouseCursorShooterHD.bmp"
  "DATA/MouseLookCursor.bmp"
  "DATA/MouseLookCursorHD.bmp"
  "DATA/SPRITES.LOD"
  "Music/2.mp3"
  "Music/3.mp3"
  "Music/4.mp3"
  "Music/5.mp3"
  "Music/6.mp3"
  "Music/7.mp3"
  "Music/8.mp3"
  "Music/9.mp3"
  "Music/10.mp3"
  "Music/11.mp3"
  "Music/12.mp3"
  "Music/13.mp3"
  "Music/14.mp3"
  "Music/15.mp3"
  "Music/16.mp3"
  "Music/17.mp3"
  "Music/18.mp3"
  "Music/19.mp3"
  "Music/20.mp3"
  "SOUNDS/Audio.snd"
  "audiere.dll"
  "audio.dll"
  "BINKW32.DLL"
  "MANUAL.PDF"
  "MAP.PDF"
  "mm7.exe"
  "MM7Patch ReadMe.TXT"
  "MM7patch.dll"
  "MM7-Rel.exe"
  "MM7Setup.Exe"
  "MP3DEC.ASI"
  "MSS32.DLL"
  "MSSA3D.M3D"
  "MSSDS3DH.M3D"
  "Mssds3ds.m3d"
  "MSSEAX.M3D"
  "Mssfast.m3d"
  "msvcp90.dll"
  "msvcr90.dll"
  "Readme.txt"
  "Reference_card.PDF"
  "SMACKW32.DLL"
  "VIC32.DLL"
)

#param {string} MM7_PATH
function cmd_install {
  local mm7path="$1"
  echo "🔨  Verify '$mm7path' installation"

  for file in "${MM7_FILES[@]}"; do
    if [[ -f "${mm7path}/${file}" ]]; then
      echo -e "  ✔️  ${file}"
    else
      echo -e "  ❌  '${file}' does not exist"
      exit 1
    fi
  done

  echo "🔨  Copy game files"
  mkdir -p Anims
  mkdir -p Data
  mkdir -p Logs
  mkdir -p MapModels
  mkdir -p MapObj
  mkdir -p Music
  mkdir -p Saves
  mkdir -p Sounds
  for file in "${MM7_FILES[@]}"; do
    cp "${mm7path}/${file}" "${file}"
    echo -e "  ✔️  ${file} copied"
  done

  #cp -r "${mm7path}/Music" Music
  #echo -e "  ✔️  Music copied"
}



pp="../mm7/DATA/00 add.icons.lod"
if ! du -sh "$pp" &> /dev/null; then
  echo "$pp file exists"
else
  echo "$pp does not exist."
fi

function cmd_run {
  echo "Mock cmd_run"
}


# Command dispatcher
while [[ $# -gt 0 ]]; do
  case "$1" in
    install)
      if [ $# -lt 2 ]; then
        echo "Error: 'install' command requires a path to the MM7 game."
        exit 1
      fi

      cmd_install "$2"
      shift
      exit 0
      ;;
    run)
      cmd_run
      exit 0
      ;;
    *)
      echo "Error: Unknown command '$1'."
      exit 1
      ;;
  esac
done