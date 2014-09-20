#!/bin/sh
# 
# File:   SubVid.sh
# Author: Giovani Paseto
#
# Created on Sep 12, 2014, 9:43:42 PM
# Add subtitle to movies
#
#IFS=$'\n'
#rename "s/\s+//g" * #remove whitespaces 
#rename 'y/A-Z/a-z/' *.* #set lowercase

currentdir=$(cd $(dirname "$1") && pwd -P)/$(basename "$1")

echo "This script will remove all blank spaces in files at this folder ($currentdir). Continue [Y/n]?"
read NAME
if [ "$NAME" != "Y" ] ; then
 exit 1
fi

find ./ -name "* *" -type d | rename 's/ //g'    # do the directories first
find ./ -name "* *" -type f | rename 's/ //g'

for movie in *.mp4 ; do
  base=$(basename $movie) 
  fn="${base%.*}"	#file name
  ext="${base##*.}" #file extension  
	for subs in $( find ./ -name '*.srt'); do 
	rename "s/\s+//g" *
		basesub=$(basename $subs) 
		fnsub="${basesub%.*}"	#file name
		extsub="${basesub##*.}" #file extension 
		if echo $fnsub | grep -iq $fn; then
			charset=$(file -bi $subs | sed -e 's/.*[ ]charset=//')
			echo "Processing $movie"
			echo "subs = $subs"
			newfile="$fn-sub.$ext"
			mencoder $movie -oac pcm -ovc lavc -sub $subs -subcp enca:tr:$charset -subfont-text-scale 3 -o $newfile
			output="File:$newfile charset: $charset\n"
		fi
	done

#  subtitle="$currentdir$fn.srt" #full sub with path
#	if [ -f "$subtitle" ]; then # if file exists add sub	
#	if [ -f "$subtitle" ]; then # if file exists add sub	
#		charset=$(file -bi $subtitle | sed -e 's/.*[ ]charset=//')
#		echo "Encoding charset: $charset"
	#	mencoder $movie -oac pcm -ovc lavc -sub "$fn.srt" -subcp enca:tr:$charset -subfont-text-scale 3 -o "$fn-sub.$ext"
#		mencoder $movie -oac pcm -ovc x264 -sub "$fn.srt" -subcp enca:tr:$charset -subfont-text-scale 3 -o "$fn-sub.$ext"
#	else
#		echo "Subtitle not found for file: $movie"
#	fi
done

printf $output


