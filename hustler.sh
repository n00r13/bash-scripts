#!/usr/bin/env bash
#########################################################################
#	Manjinder Singh							#
#	  2018-06-21							#
#									#
#	script :	hustler.sh					#
#	Function : downloads top 100 - monthly songs from djpunjab 	#
#	 								#
#	- Parameters : $1 = destination folder				#
#########################################################################


dest=$1
if [ ! -f downloads_log ];then
        touch downloads_log
fi
curl -L https://ww.djpunjab.com/page/top20_month.html >> a
grep -oP "single.*?html" a > b
mv b a
i=1
while read a; do
        echo $i 
        echo $a
        curl -L https://ww.djpunjab.com/$a >> m
        i=$((i+1))
	echo "--------------------------------------------"
done <a
grep -oP "........320.*?mp3" m > links
rm a
rm m
downloads=0
skipped=0
while read link; do
        echo $link
        if grep -q "$link" downloads_log;then
                echo "--------------------------------"
                echo "Previously downloaded"
                echo "--------------------------------"
                skipped=$((skipped+1))
        else
                wget -nc "$link" -P "$dest"
                downloads=$((downloads+1))
                if [ $? -eq 0 ];then
                        echo $link >> downloads_log
                fi
        fi
done <links
echo "Downloads : $downloads  , Skipped : $skipped"
rm links
