#!/bin/bash
#
# Speed Test Journalist for Cron or Daemon, License: GPLv3
# Author: Rojen Zaman <rojen@riseup.net> rojenz.de
#
# Note: This program use speedtest.net tool of "speedtest-cli",
#	please read Privacy Policy* before perform this script in your system.
#	*: https://www.speedtest.net/about/privacy

# usage
usage() {
echo "usage: ./`basename $0` [-v] [-p|-i|-l|-r] [-h]"
echo " -v	verbose output"
echo " -p	print journals as html file (image gallery)"
echo " -i	download png files from /var/log/speedtestdjournal/log.json"
echo " -l	list all speedtest results as table from /var/log/speedtestdjournal/json/*.json"
echo " -r	remove empty logs"
echo " -h	display help page"
exit 0
}

# configuration section
journal_path=$HOME/speedtestdjournal			# default journal path is under at home directory as speedtestdjournal
json_log=$journal_path/log.json                         # json log for print html
timestamp=`date +%s`                                    # set timestamp
file_date=$(date +"%Y-%m-%d_%H-%M" -d "@$timestamp")    # default file time format, use unix time "%s" insted of this
json_file=$journal_path/json/$file_date.json            # set file name and location for main script
image_file=$journal_path/image/$file_date.png           # set image name and location for main script
#usr_arg="--no-download"                                # uncomment if you want do not perform download test
#usr_arg="--no-upload"                                  # uncomment if you want do not perform upload test
#usr_arg2=""                                            # set any speedtest-cli argument if you want
#server="--server SERVER"                               # specify a server ID to test against.
share="--share"                                         # if you don't want create image files from speedtest.net uncomment this
#exclude="--exclude EXCLUDE"                            # exclude a server from selection. Can be supplied multiple times
ssl="--secure"                                         # use HTTPS instead of HTTP when communicating with speedtest.net operated servers


# print html
print_html() {                                          # image div
image_div() {
url_list=$(mktemp)
cat $json_log | jq -r '.remote_png, .timestamp' | paste - - > $url_list
while IFS=$'\t' read -r remote_png timestamp
do
cat <<EOF
<div class="gallery"> <a target="_blank" href="$remote_png"> <img src="$remote_png" alt="$timestamp" width="600" height="400"> </a> <div class="desc">$(date +"%B %d, %Y - %T" -d @$timestamp)</div> </div>
EOF
done < $url_list
rm $url_list
}							# main html
cat <<EOF
<!DOCTYPE html> <html> <head> <title>Speed Test Logs</title> <meta http-equiv="content-type" content="text/html;charset=utf-8" /> <meta name="generator" content="speedtestdjournal.sh" /> <meta name="viewport" content="width=device-width, initial-scale=1" /> <style> div.gallery { margin: 5px; border: 1px solid; float: left; width: 320px; } div.gallery:hover { border: 1px solid } div.gallery img { width: 100%; height: auto; } div.desc { padding: 15px; text-align: center; } </style> </head> <body> <h1>Speed Test Journal (image logs)</h1> <p>generated by <a href="https://github.com/rojenzaman/speedtestdjournal">speedtestdjournal.sh</a></p> <hr/> $(image_div) </body></html>
EOF
exit 0
}

download_png() {					# download png files
download_list=$(mktemp)
cat $json_log | jq -r '.png_file, .remote_png' | paste - - > $download_list
while IFS=$'\t' read -r png_file remote_png
do
wget --no-verbose -nc -O $journal_path/image/$png_file "$remote_png"
done < $download_list
rm $download_list
exit 0
}

table_result() {					# list test results as table. (it is a template, must be developed)
(echo -e "DOWNLOADS\nUPLOADS"; cat $journal_path/json/* | jq -r '.download, .upload' | xargs numfmt --to iec --format "%8.2f") | paste - -
exit 0
}

remove_empty() {
log_list=$(mktemp)
cat $journal_path/log.json | jq -r '.timestamp, .remote_png' | paste - - > $log_list
while IFS=$'\t' read -r timestamp remote_png;
do
[ -z $remote_png ] && grep -v "$timestamp" $journal_path/log.json > /tmp/log.json && mv /tmp/log.json $journal_path/log.json;
done < $log_list
rm $log_list
find $journal_path -size  0 -print -delete
exit 0
}

while getopts ":hvpilr" opt; do				# check optional arguments
  case ${opt} in
    h ) usage ;;
    v ) set -x ;;
    p ) print_html ;;
    i ) download_png ;;
    l ) table_result ;;
    r ) remove_empty ;;
    \? ) usage ;;
  esac
done


# check dir and programs
mkdir -p $journal_path/{json,image}                     # check and create save dir
echo "don't delete log.json" > $journal_path/README     # warning

[ -x "$(command -v jq)" ] || {				# check jq
echo "jq not found, please install it."
exit 1
}
[ -x "$(command -v speedtest-cli)" ] && {		# check speedtest-cli
cli="speedtest-cli"
} || {
	[ -x "$(command -v speedtest.py)" ] && {
		cli="speedtest.py"
		} || {
		echo "speedtest-cli not found, please install it."
		exit 1
	}
}
[ -x "$(command -v wget)" ] || {			# check  wget
	echo "wget not found, please install it."
	exit 1
}


# main
                                                        # save speedtest output as json. remove pipe and jq command for writing pure json when journaling
$cli --json $share $usr_arg $server $exclude $ssl $usr_arg2 > $json_file
remote_png=$(cat $json_file | jq -r '.share')
wget -O $image_file "$remote_png" &>/dev/null 		# save speedtest output as png. uncomment this if you don't want.

							# json log
[ -f $json_file -a -f $image_file ] && cat >> $json_log <<EOF
{"json_file":"$file_date.json","png_file":"$file_date.png","timestamp":"$timestamp","remote_png":"$remote_png"}
EOF

exit 0
