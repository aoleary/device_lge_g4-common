#!/bin/bash
#
# create_multi_surface_image.sh
#
# Tool to convert multiple PNG images into a single "Multi Surface Image"
# supported by Android 6.0 as a animated boot charging
#
# Requirements:
#  - ImageMagick (convert)
#  - exiftool
#  - pngcrush
#
# Author: Cristiano da Cunha Duarte - cunha17@gmail.com
##

# Configuration parameters (source files and destination file)
FILES=`ls battery_?.png`
SCALEFILE=battery_scale.png

#
FRAMES=`ls $FILES | wc -l`
echo "Frames: $FRAMES"
FIRST=`ls $FILES | head -1`
IMAGEWIDTH=`exiftool $FIRST | grep "^Image Width " | cut -d: -f 2 | xargs`
IMAGEHEIGHT=`exiftool $FIRST | grep "^Image Height " | cut -d: -f 2 | xargs`
SCALEHEIGHT=$(($IMAGEHEIGHT*$FRAMES))

###
# Since there is a bug in libpng that does not recognize text chunks after
# data chunk, and ImageMagick always place the text chunks after the Data
# chunk, the next line would only work after the BUG in libPNG is corrected:
# BUG report #248 PNG specification violation: time and text chunks after
#                 IDAT are not being processed
#                 (https://sourceforge.net/p/libpng/bugs/248/)
##
#convert -set "Frames" "6" -size ${IMAGEWIDTH}x${SCALEHEIGHT} canvas:black $FILES -fx "u[j%$FRAMES+1].p{i,int(j/$FRAMES)}" png24:$SCALEFILE

##
# Need to split the previous command into two:
# 1) create the PNG
# 2) put the text chunk before the data chunk
##
convert -size ${IMAGEWIDTH}x${SCALEHEIGHT} canvas:black $FILES -fx "u[j%$FRAMES+1].p{i,int(j/$FRAMES)}" png24:$SCALEFILE.tmp
pngcrush -text b "Frames" "$FRAMES" $SCALEFILE.tmp $SCALEFILE && rm $SCALEFILE.tmp
