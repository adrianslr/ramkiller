#! /bin/bash

# Simple script to stop an app with high RAM usage.
# (c) https://github.com/pislaru/

iMaxUsage=512000 #This is the maximum memory usage permited !
procName="proc_name" #This is the name of the process that we want to control !

#Here we took all the pids of the running $procName processes

iPids=$( ps -U root -u root -N | grep $procName | grep -o -P "(.*)(?=pts)");

#Here we parse the PIDS and search for HIGH MEMORY USAGE !

for i in $iPids
do
#Here we check all the usages for that PIDS !

iMemoryUsage=$( pmap $i | awk -F"total" '{print $2}' | grep K | tr -d " " | tr -d "K" );

#Here we will compare with the maximum MEMORY USAGE PERMITED!
#Also, we kill the process and log it to know at any time who was the joker :).

if [ $iMemoryUsage -gt $iMaxUsage ]
then
sPidOwner=$(ps -ef | grep $i | grep -o -P '(.*)(?=$i)' | cut -d"r" -f1 | grep " ");  # Sometimes Unstable.
sDateAndTime=$(date)
kill $i
echo "Date and time : $sDateAndTime , user : $sPidOwner ;" >> /home/ramkiller.log
fi
done

#Script job done !
