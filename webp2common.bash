#!/usr/bin/bash
echo "if you are using the ImageMagick AppImage and it is not in the system path, please place it in your home directory."
if ! which magick; then loc="${HOME}/"; else loc=""; fi
if ! which ${loc}magick; then read -p "ImageMagick could not be found. Please install ImageMagick using your package manager or download the ImageMagick AppImage from their website. If you have already downloaded the AppImage, please either add it to your PATH variable or place it in the home directory." && exit 1; fi
echo "take note of your ImageMagick version..."
${loc}magick -version
animformat="gif"
magickversion=$(${loc}magick -version | head -1 | cut -d' ' -f3 | sed 's/\.//g' | sed 's/-/\./g')
echo "$magickversion"
if [[ $magickversion>=7110.20 ]] && which ffmpeg; then 
 echo "detected version is greater than or equal to 7.1.10-20, Please create an issue at Thysbelon/webp2common on GitHub if your actual ImageMagick version is less."
 echo "ffmpeg is installed"
 echo "use animated png instead of gif? y/n"
 read apngpref
 [[ "$apngpref" = "y" ]] && animformat="apng"
else
 echo "detected version is less than 7.1.10-20 *or* ffmpeg is not installed; Please create an issue at Thysbelon/webp2common on GitHub if your actual ImageMagick version is greater or equal."
fi
for i in *.webp; do 
 echo "$i"
 if ${loc}magick identify "$i" | grep "webp\["; then
  echo "animated webp"
  ${loc}magick "$i" "${i%.*}.${animformat}"
 else
  echo "not an animated webp"
  ${loc}magick "$i" "${i%.*}.png"
 fi
done
echo "Delete all webp? y/n"
read delanswer
[[ "$delanswer" = "y" ]] && rm *.webp
