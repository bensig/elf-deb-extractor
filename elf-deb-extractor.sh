#!/bin/bash
# Script to extract all ELF binaries from deb files in an apt repo
DIR=/var/spool/apt-mirror/
EXTRACTED_DIR=~/extracted/
UNTAR_DIR=~/untard
ELF_DIR=~/elf-files/

# go to temp dir which we will use for extraction of files
cd $EXTRACTED_DIR

# find deb files and extract files
for i in $(find $DIR -name "*.deb")
  do
    #extract deb files with ar
    ar -x $i
    # see if we got any data gz or xz and extract them into an untar dir
    find . -name "data.tar.gz" -exec tar -zxvf {} -C $UNTAR_DIR \;
    find . -name "data.tar.xz" -exec tar -xvf {} -C $UNTAR_DIR \;
    cd $UNTAR_DIR
# test if files are ELF, if they are ELF then move them to $ELF_DIR
	find . -type f -print0 | xargs -0 file | grep ELF| cut -d: -f1| grep -Ev ".sh$|.o$|.py$|.so$|.so.[0-9]$|.so.[0-9].[0-9]" while read LINE; do
        mv $LINE $ELF_DIR
      done
   done
