#!/bin/bash
#i-c138d3b3 stopped stapp m1.medium 10.234.3.247
#keypairs of each environment
keypairdev="integ"
keypairprod="stapp|stdb|vpc-public-10-234-1"
keypairstage="scp-staging"
#temporal files to handle AWS data get with ec2tools
tmpFile="/tmp/ec2.info"
tmpFile2="/tmp/ec2tags.info"
tmpFile3="/tmp/ec2volumes.info"
#menu for user
echo "Choose the environment that you want to get a instances inventory 1,2,3 "
echo "1. Prod"
echo "2. Staging"
echo "3. Dev"
echo "if you want to make a volume snapshot after get the instances lists of the environment execute ec2-create-snapshot putherevol-id --description \"Daily Backup\""
read answer
echo "Searching instances"
#set the keypair regarding to the choice of the user
case $answer in
	1) keypair=$keypairprod;; 
	2)  keypair=$keypairstage ;;
	3)  keypair=$keypairdev ;;
	*) echo "INVALID NUMBER!" ;;
esac
#it gets all the volumes per instances and save in a temporal file
ec2Info=`ec2-describe-volumes > $tmpFile3`
#it gets all of the instances with the chosen keypair that identify servers of one environment
ec2Info= $(ec2-describe-instances |grep INSTANCE | egrep $keypair| awk {'print $2, $4, $5, $7,  $12, $NF'} > $tmpFile)
#get the tag with the name of the machines in a different temporal file
 ec2name=`ec2-describe-tags --filter "resource-type=instance"  > $tmpFile2 `
#get the instances id stored in the temporal file that contains the servers of the chosen environment 
 nstances=`cat $tmpFile |  awk {'print $1'}`
#count the number of instances that are part of the chosen environment 
 numOfInstances=`cat $tmpFile | grep running | wc -l`
 you=`whoami`
echo "The instances you have, by hostname, are as follows ..."
echo "You have $numOfInstances instances running  that fit in your search running"
 for instance in $nstances
 do
	#get the fields that we want for each instance
	keypair=`cat $tmpFile |  grep $instance | awk {' print $3 '}`
        status=`cat $tmpFile |  grep $instance | awk {' print $2 '}`
	ip=`cat $tmpFile |  grep $instance | awk {' print $5 '}`
        id=$instance
	size=`cat $tmpFile  | grep $instance | awk {' print $4 '}`
	#TAG     instance        i-da0ac0a9      Name    STAGING-public-webserver2
	name=`cat  $tmpFile2 | grep $instance |awk {'print $5'} `
	#name=`cat $tmpFile  | grep $instance | awk {' print $6 '}`
        #prodapp-type2-smp5 -  running - 10.234.3.76 - i-8b12fcf9 - m1.xlarge stapp
	#volumes=`ec2-describe-instance-attribute $instance -b`
	volumes=`cat  $tmpFile3 | grep $instance |awk {'print $2'} `
	#echo "$name | $status | $ip | $id | $size | $keypair| $volumes"
	echo "*******************************************************"
	echo "Instance name - status - IP - instance ID - Size - Keypair - Volumes"
	echo "*******************************************************"
	echo "$name | $status | $ip | $id | $size | $keypair| $volumes"
	echo "---------------------------------------------------------------------" 
done
echo "if you want to make a volume snapshot after get the instances lists of the environment execute ec2-create-snapshot puthevol-id --description \"Daily Backup\""
