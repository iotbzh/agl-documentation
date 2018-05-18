#!/bin/bash

cd $(dirname $0)

FORMAT=pdf
#DEBUG_FLAG=--log=debug
DEBUG_FLAG=

DRY=
[ "$1" = "-dry" ] && DRY=echo

OUT_DIR=./build
[ -d $OUT_DIR ] || mkdir -p $OUT_DIR

GITBOOK=`which gitbook`
[ "$?" = "1" ] && { echo "You must install gitbook first, using: sudo npm install -g gitbook-cli"; exit 1; }

EBCONV=`which ebook-convert`
[ "$?" = "1" ] && { echo "You must install calibre first, please refer to https://calibre-ebook.com/download"; exit 1; }

cat <<EOF | { while read doc_dir output_file; do $DRY $GITBOOK install $doc_dir; $DRY $GITBOOK $FORMAT $doc_dir $OUT_DIR/$output_file $DEBUG_FLAG; done }
./sdk-devkit AGL-Development-Kit.pdf
EOF

