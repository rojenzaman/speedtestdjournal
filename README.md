# speedtestdjournal
speedtest-cli Journalist for Cron or any Daemon.

This script create speedtest-cli journals as json and image data and it can also print them as [html](https://rojenzaman.github.io/speedtestdjournal.html).

*speedtestdjournal uses **speedtest.net** tool of `speedtest-cli`, please read [Privacy Policy](https://www.speedtest.net/about/privacy) before perform this script in your system.*


## Install

Go to your prefer script path (such as in here /usr/bin) and install it:
```
$ curl https://raw.githubusercontent.com/rojenzaman/speedtestdjournal/main/speedtestdjournal.sh > /usr/bin/speedtestdjournal.sh
$ chmod 755 /usr/bin/speedtestdjournal.sh
```

## Simple Usage

```
$ speedtestdjournal.sh -h
usage: ./speedtestdjournal.sh [-p] [-v] [-h]
 -p       print journals as html file (image gallery)
 -v       verbose output
 -h       display help page
```

## Set Journal Path (log files path)
In default journal path is under home directory as `$HOME/speedtestdjournal/`. We suggest `/var/log/speedtestdjournal/` directory for posixly.
Change it:
```bash
journal_path=/var/log/speedtestdjournal # go to line 20 and set journal_path string to /var/log/speedtestdjournal
```

## Set as a Crontab
Set crontab to perform automate, it is good idea to logging. 
You can set @weekly @hourly @monthly @daily or any cron param.
```
$ crontab -e
@daily speedtestdjournal.sh
```

## Print Test Results as HTML From Journal
An example at here [speedtestdjournal.html](https://rojenzaman.github.io/speedtestdjournal.html)
```
$ speedtestdjournal.sh -p > output.html
```

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

## Verbosing
```
$ speedtestdjournal.sh -v
```
or

```
$ speedtestdjournal.sh -v -p
```

## TODO
* Print html with detailed tables
* Beauty html
* Json parsing html

### Contribution
Please go to `Issues` or `Pull requests`
