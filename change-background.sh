#!/bin/bash
# List of possible arguments:
#   new
#   erotica
#   3d-graphics
#   animals
#   anime
#   aviation
#   cars
#   celebrities
#   food
#   games
#   girls
#   holidays
#   men
#   motorcycles
#   movies
#   music
#   nature
#   space
#   sport
#   various
#   world

downloadImage(){
    declare -A eroWallpapers=( [erotica]=1 [hentai]=1)
    if [[ ${eroWallpapers["$1"]} ]] ; then
        mainPage='https://ero.motaen.com'
    else
        mainPage='https://motaen.com'
    fi

    case $1 in
        new)
            images="${mainPage}"'/new'
            ;;
        aviation)
            images="${mainPage}"'/categories/view/name/avia'
            ;;
        cars)
            images="${mainPage}"'/categories/view/name/auto'
            ;;
        men)
            images="${mainPage}"'/categories/view/name/male-celebrities'
            ;;
        various)
            images="${mainPage}"'/categories/view/name/other'
            ;;
        *)
            images="${mainPage}"'/categories/view/name/'"$1"
            ;;
    esac

    # get the link to a image
    xpathGeneral='/html/body/main/div[@class="parent-element"]'

    # random number:
    randomImage=$((2+$RANDOM%15))
    xpathImage="${xpathGeneral}"'/div[@class="content col-md-12 col-xs-12"]/ul[@class="element"]/li['"${randomImage}"']/a/@href'
    image=$(curl -s $images | xmllint --html --xpath "string($xpathImage)" -)
    imagePage="${mainPage}${image}"

    xpathDownload="${xpathGeneral}"'/div[@class="content col-md-12 col-xs-12"]/div[@class="lig-cnt col-md-8"]/div[@class="download-wallpaper"]/ul[1]/li[2]/a/@href'
    downloadWallpaper=$(curl -s $imagePage | xmllint --html --xpath "string($xpathDownload)" -)
    downloadWallpaperPage="${mainPage}${downloadWallpaper}"

    # complete
    xpathFullImage="${xpathGeneral}"'/div[@class="this_download col-md-12 col-xs-12"]/div[@class="full-img col-md-9"]/img/@src'
    fullImage=$(curl -s $downloadWallpaperPage | xmllint --html --xpath "string($xpathFullImage)" -)

    nameFullImage=$(echo $fullImage | grep -Eow "[^\/]*\.jpg$" -)
    pathToImage='/home/matheth/Pictures/desktop-wallpapers/'"${nameFullImage}"

    curl "${mainPage}${fullImage}" > "${pathToImage}"
    echo "${pathToImage}"
}
desktop="$(downloadImage $1)"
lockscreen="$(downloadImage $1)"

# SET DESKTOP PICTURE
gsettings set org.gnome.desktop.background picture-uri "file://${desktop}"
# SET LOCKSCREEN PICTURE
gsettings set org.gnome.desktop.screensaver picture-uri "file://${lockscreen}"
