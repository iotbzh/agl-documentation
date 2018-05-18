#!/bin/bash

TITLE="AGL Development Kit"
SUBTITLE="Developer Documentation"
VERSION="Version 3.1"
DATE="March 2017"

cat cover.svg | sed -e "s/{title}/$TITLE/g" \
    -e "s/font-size:87.5px/font-size:50px/g" \
    -e "s/{subtitle}/$SUBTITLE/g" \
    -e "s/font-size:62.5px/font-size:45px/g" \
    -e "s/{version}/$VERSION/g" \
    -e "s/{date}/$DATE/g" \
    > /tmp/cover.svg

# use  imagemagick convert tool  (cover size must be 1800x2360)
convert -resize "1600x2160!" -border 100 -bordercolor white -background white \
    -flatten -quality 100 /tmp/cover.svg ../cover.jpg
[ "$?" = "1" ] && { echo "Error while generating cover.jpg"; exit 1; }

convert -resize "200x262!" ../cover.jpg ../cover_small.jpg
[ "$?" = "1" ] && { echo "Error while generating cover_small.jpg"; exit 1; }
