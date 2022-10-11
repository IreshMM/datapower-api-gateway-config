#!/usr/bin/expect -f

set host [ lindex $argv 0 ]
set command [ lindex $argv 1 ]

set timeout -1
spawn ssh -t -o "StrictHostKeyChecking=no" $host telnet localhost 2200
match_max 100000
expect "*login: "
send -- "admin\r"
expect "*Password: "
send -- "admin\r"
expect "*idg# *"
send -- "$command\r"
expect "*idg# *"
send -- "exit\r"
expect eof
