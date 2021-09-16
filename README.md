# speedtestdjournal
speedtest-cli Journalist for Cron or any Daemon.

This script create speedtest-cli journals as json and image data and it can also print them as [html](https://rojenzaman.github.io/speedtestdjournal.html).

*speedtestdjournal uses **speedtest.net** tool of `speedtest-cli`, please read [Privacy Policy](https://www.speedtest.net/about/privacy) before perform this script in your system.*

## Journaling Format

### tree of /var/log/speedtestdjournal/

```
.
├── image
│   ├── 2020-11-24_00-59.png
│   └── 2020-11-24_01-26.png
├── json
│   ├── 2020-11-24_00-59.json
│   └── 2020-11-24_01-26.json
├── log.json
└── README

```

### log.json

```
{"json_file":"2020-11-24_00-59.json","png_file":"2020-11-24_00-59.png","timestamp":"1606175962", "remote_png":"http://www.speedtest.net/result/10471496503.png"}
{"json_file":"2020-11-24_01-26.json","png_file":"2020-11-24_01-26.png","timestamp":"1606177577", "remote_png":"http://www.speedtest.net/result/10471582209.png"}
```


## Install

Switch to [non-root user](#non-root-user) section for rootless setup.

Go to your prefer script path (such as in here /usr/bin) and install it:
```
# wget -O /usr/bin/speedtestdjournal.sh https://raw.githubusercontent.com/rojenzaman/speedtestdjournal/main/speedtestdjournal.sh
# chmod 755 /usr/bin/speedtestdjournal.sh
```


## Set Journal Path (log files path)
In default journal path is under home directory as `$HOME/speedtestdjournal/`. We suggest `/var/log/speedtestdjournal/` directory for posixly. This is require root user, and run with root.
Change it:
```bash
journal_path=/var/log/speedtestdjournal # go to line 20 and set journal_path string to /var/log/speedtestdjournal
```

## Create Daemon
Now we create speed test daemon to run every an hour. You can change the per time value.

### Way 1 - Set as a Crontab
Set crontab to perform automate, it is good idea to logging. 
You can set @weekly @hourly @monthly @daily or any cron param.
```
# crontab -e
@hourly /usr/bin/speedtestdjournal.sh
```

### Way 2 - Systemd Service
Create systemd service to perform automate, it is good idea to logging. 

Get service file
```
# curl -O https://raw.githubusercontent.com/rojenzaman/speedtestdjournal/main/speedtestjournal.service
```
Copy it to systemd service files directory, and give correct permission to the file.
```
# cp speedtestjournal.service /etc/systemd/system/
# chmod 644 /etc/systemd/system/speedtestjournal.service
```
Reload and reexec the systemd services:
```
# systemctl daemon-reexec
# systemctl daemon-reload
```
Start service
```
# systemctl start speedtestjournal.service
```
Check it
```
# systemctl status speedtestjournal.service
```
View journalctl log
```
# journalctl -u speedtestjournal.service
```


## Speedtest-cli Configuration
```bash
#usr_arg="--no-download"                                # uncomment if you want do not perform download test
#usr_arg="--no-upload"                                  # uncomment if you want do not perform upload test
#usr_arg2=""                                            # set any speedtest-cli argument if you want
#server="--server SERVER"                               # specify a server ID to test against.
share="--share"                                         # if you don't want create image files from speedtest.net uncomment this
#exclude="--exclude EXCLUDE"                            # exclude a server from selection. Can be supplied multiple times
#ssl="--secure"                                         # use HTTPS instead of HTTP when communicating with speedtest.net operated servers
```
> Note: This script can understand if the cli command is speedtest-cli or speedtest.py


## Simple Usage

```
# speedtestdjournal.sh -h
usage: ./speedtestdjournal.sh [-v] [-p|-i|-l] [-h]
 -v	verbose output
 -p	print journals as html file (image gallery)
 -i	download png files from /var/log/speedtestdjournal/log.json
 -l	list all speedtest results as table from /var/log/speedtestdjournal/json/*.json
 -h	display help page
```

For get instant speed test just type:

```
# speedtestdjournal.sh
```
And get it:

```
# speedtestdjournal.sh -l | tail -1
```


## Functions


### Print Test Results as HTML From Journal
An example at here [speedtestdjournal.html](https://rojenzaman.github.io/speedtestdjournal.html)
```
# speedtestdjournal.sh -p > output.html
```


### Verbosing
```
# speedtestdjournal.sh -v
```
or

```
# speedtestdjournal.sh -v -p
```

### Download PNG files

download png files from log.json

```bash
# speedtestdjournal.sh -i  # if image exist will skip
```

### List Results as Table (template)

list all speedtest results as table from speedtestdjournal/json/*.json

```
# speedtestdjournal.sh -l
DOWNLOADS	UPLOADS
   9.39M	 829.62K
  12.87M	 781.28K
  12.54M	 791.03K
  12.74M	 829.52K
  12.76M	 661.64K
  12.87M	 793.82K
  12.67M	 681.81K
```

## Non-Root User

Go to your user PATH
```
$ cd ~/bin
```
or
```
$ cd ~/.local/bin
```
And download it.
```
$ wget https://raw.githubusercontent.com/rojenzaman/speedtestdjournal/main/speedtestdjournal.sh
$ chmod 750 speedtestdjournal.sh
```
You can run now, the journal path is `$HOME/speedtestdjournal`. It is under home directory, you can change this with **journal_path** string.
Finally create crontab:
```
$ crontab -e
@hourly /home/YOURUSERNAME/bin/speedtestdjournal.sh
```


## TODO
* Print html with detailed tables
* Beauty html
* Json parsing html
* Create POSIX-SH Compliant version
* Require testing under OS X and BSD unix

### Contribution
Please go to `Issues` or `Pull requests`
