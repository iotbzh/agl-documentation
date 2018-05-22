#!/bin/bash

cd $(dirname $0)
CURDIR=$(pwd)

FORMAT=pdf
#DEBUG_FLAG=--debug
DEBUG_FLAG=

DRY=
[ "$1" = "-dry" ] && DRY=echo

OUT_DIR=./build
[ -d $OUT_DIR ] || mkdir -p $OUT_DIR

cat <<EOF | { while read doc_dir output_file; do $DRY $doc_dir/gendocs.sh -o $OUT_DIR/$output_file $DEBUG_FLAG $FORMAT; done }
./sdk-devkit AGL-Development-Kit.pdf
./host-configuration AGL-Host-Configuration.pdf
./candevstudio AGL-CanDevStudio.pdf
EOF

