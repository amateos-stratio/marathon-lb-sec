#! /bin/bash
for run in {1..300}
do
     curl $1:9090/_mlb_signal/usr1
     sleep 5
done