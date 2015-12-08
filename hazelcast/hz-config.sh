#!/bin/bash
stackname=`uname -a | awk {'print $2'} | awk -F "-" {'print $1'}`
rm hzservers
counter=1
while true
do
host="$stackname-hz$counter"

ping -q -c 1 $host
ecode=`echo $?`
        if
                [ "$ecode" = 0 ]
        then
                echo $host >>hzservers
                ((counter++))
                #$counter=$(expr $counter + 1)
        else
                echo "no more servers"
                break
        fi
done
servers=`cat hzservers`

for i in $servers
do
echo "server:" $i
echo "running awk"
awk '{print} /<member-list>/{ print substr($0,1,match($0,/[^[:space:]]/)-1) "<member>'$i'</member>" }' hazelcast.xml >>hazelcast.xml.new
echo "done running aws"
done

#echo "exitcode:"$ecode

#if
#for i in $array
#do
#       if
#               [ $i
