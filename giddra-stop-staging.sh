#!/bin/bash
echo "Turning staging off" > /tmp/staging.log
./ec2-list.sh  Staging |grep "i-"| grep -v redis| grep -v mongo > /tmp/staging.txt
/ec2-list.sh  Prod |grep STAGING-public-webserver >>  /tmp/staging.txt
ec2instances=$(cat /tmp/staging.txt|awk {'print $7'})
for instance in $ec2instances
 do
	echo "instance $instance is about to be halted" >> /tmp/staging.log
        echo "ec2-stop-instances $instance"
 done
#change email account for support expression
#send email with ops.frog email account and mutt in prod
#echo "Staging has been turned off"  | mutt -s "Staging turned off" -a /tmp/staging.txt  -- support.expression.device.global@lumatagroup.com  david.martinez@lumatagroup.com christopher.cunningham@lumatagroup.com
mail -s "Turning Staging off" juan.vicente.herrera@gmail.com < /tmp/staging.txt	
