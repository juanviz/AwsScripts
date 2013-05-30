#!/bin/bash
# author: Juan Vicente Herrera 
# juanvicenteherrera.eu
#pre requisites
#have ec2tools installed and working in workstation
#all of the servers of a environment have to have the same keypair
#if not change keypair variable for the field which identify the environment of the server
#keypairs of each environment
keypairdev="integ"
keypairstage="scp-staging"
#temporal files to handle AWS data get with ec2tools
tmpFile="/tmp/ec2.info"
tmpFile2="/tmp/ec2tags.info"
tmpFile3="/tmp/ec2volumes.info"
keypair="none"
echo "Turning staging off" > /tmp/staging.log
if [ "$1" = "Staging" ];then 
	keypair=$keypairstage

elif [ "$1" = "Dev" ];then
	keypair=$keypairdev

else 
	echo "Invalid environment. Valid environments are  Staging and Dev"
	echo "Example: $0 Staging"
fi
if [ "$keypair" != "none" ];
	then
#it gets all the volumes per instances and save in a temporal file
ec2Info=`ec2-describe-volumes > $tmpFile3`
#it gets all of the instances with the chosen keypair that identify servers of one environment
ec2Info= $(ec2-describe-instances |grep INSTANCE | egrep $keypair| awk {'print $2, $4, $5, $7,  $12, $NF'} | grep -v redis| grep -v mongo > $tmpFile)
#get the tag with the name of the machines in a different temporal file
 ec2name=`ec2-describe-tags --filter "resource-type=instance"  > $tmpFile2 `
#get the instances id stored in the temporal file that contains the servers of the chosen environment 
 nstances=`cat $tmpFile |  awk {'print $1'}`
#count the number of instances that are part of the chosen environment 
 numOfInstances=`cat $tmpFile | grep running | wc -l`
 you=`whoami`
echo "The instances you have, by hostname, are as follows ..."
echo "Shutdown instances"
 for instance in $nstances
 do
	#get the fields that we want for each instance
	keypair=`cat $tmpFile |  grep $instance | awk {' print $3 '}`
    status=`cat $tmpFile |  grep $instance | awk {' print $2 '}`
	ip=`cat $tmpFile |  grep $instance | awk {' print $5 '}`
    id=$instance
	size=`cat $tmpFile  | grep $instance | awk {' print $4 '}`
	name=`cat  $tmpFile2 | grep $instance |awk {'print $5'} `
	volumes=`cat  $tmpFile3 | grep $instance |awk {'print $2'} `
	#echo "$name | $status | $ip | $id | $size | $keypair| $volumes"
	echo "instance $name with ip $ip is about to be halted" >> /tmp/staging.log
	echo "ec2-stop-instances $id"
done
else echo "Nothing to do"
fi

