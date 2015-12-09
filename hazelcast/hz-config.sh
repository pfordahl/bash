#!/bin/bash
hzxml=/opt/hazelcast/hazel*/bin/hazelcast.xml
stackname=`uname -a | awk {'print $2'} | awk -F "-" {'print $1'}`
counter=1
errorcount=1
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
        elif
                [ "$errorcount" = 10 ]
        then
                break
                echo "no more servers"
        else
                ((counter++))
                ((errorcount++))
                echo "errorcount:"$errorcount

        fi
done
servers=`cat hzservers`

for i in $servers
do
echo "server:" $i
echo "running awk"
sed -i 's/localhost/'$stackname-mc1'/g' $hzxml
sed -i '/<member-list>/a  \                      \<member>'$i'</member>' $hzxml
echo "done running aws"
done
rm hzservers
