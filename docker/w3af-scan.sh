#!/bin/sh

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

set -x
set -e

/tmp/moth-venv/bin/python django-moth/start_daemons.py --log-directory=/tmp/ &

# Let the daemons start
sleep 5

#
#   Create the script
#
cat << EOF > /tmp/test-script.w3af
plugins
output console,text_file
output config text_file
set output_file /tmp/w3af-log-output.txt
set http_output_file /tmp/output-http.txt
set verbose True
back
output config console
set verbose True
back

audit sqli

crawl web_spider
crawl config web_spider
set only_forward True
back

grep all

back
target
set target http://127.0.0.1:8000/audit/sql_injection/
back

misc-settings
set max_discovery_time 2
set fuzz_form_files false
back

start

exit
EOF

#
#   Make sure that we accept the terms and conditions
#
cat << EOF > ~/.w3af/startup.conf
[STARTUP_CONFIG]
auto-update = false
frequency = D
last-update = 2014-04-10
last-commit = 114fc0cd6f339c1a5c98da8ab88aec5ee6b928fc
accepted-disclaimer = true
EOF

#
# Run the scan
#
w3af_console -s /tmp/test-script.w3af


#
# Assert that stuff was found
#
grep 'SQL injection in' /tmp/w3af-log-output.txt
grep 'The ClamAV plugin failed to connect' /tmp/w3af-log-output.txt
grep 'A comment containing "Fixed navbar"' /tmp/w3af-log-output.txt
grep 'The whole target has no protection' /tmp/w3af-log-output.txt
