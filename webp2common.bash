#!/usr/bin/bash
echo "if you are using the ImageMagick AppImage and it is not in the system path, please place it in your home directory."
if ! magick -version; then loc="${HOME}/"; else loc=""; fi
echo "take note of your ImageMagick version..."
${loc}magick -version
animformat="gif"
animformat2=""
magickversion=$(${loc}magick -version | head -1 | cut -d' ' -f3 | sed 's/\.//g' | sed 's/-/\./g')
echo "$magickversion"
if [[ $magickversion>=7110.20 ]] && which ffmpeg; then 
 echo "detected version is greater than or equal to 7.1.10-20, Please create an issue at Thysbelon/webp2common on GitHub if your actual ImageMagick version is less."
 echo "ffmpeg is installed"
 echo "use animated png instead of gif? y/n"
 read apngpref
 [[ "$apngpref" = "y" ]] && animformat="png" && animformat2="apng:"
else
 echo "detected version is less than 7.1.10-20 *or* ffmpeg is not installed; Please create an issue at Thysbelon/webp2common on GitHub if your actual ImageMagick version is greater or equal."
fi
for i in *.webp; do 
 echo "$i"
 if ${loc}magick identify "$i" | grep "webp\["; then
  echo "animated webp"
  ${loc}magick "$i" "${animformat2}${i%.*}.${animformat}"
 else
  echo "not an animated webp"
  ${loc}magick "$i" "${i%.*}.png"
 fi
done
echo "Delete all webp? y/n"
read delanswer
[[ "$delanswer" = "y" ]] && rm *.webp