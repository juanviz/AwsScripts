AwsScripts
==========

 Scripts to ease the way to execute some common and frequent operations related to your AWS services
 
 author: Juan Vicente Herrera 
 
 juanvicenteherrera.eu

ec2-instances.py
==========

 requisites: boto python module installed
 
 sudo pip install boto
 
 script that start, stop or list the instances of an environment
 
 All of the instances of an environment has to have a tag called "Env" with one of the values defined in the config.py file
 
 Example of usage ./ec2-instances.py stop Dev
 
 Dev is the value of Tag "Env" in all of the instances that compose dev environment and is defined in config.py
 
 as the value of Env Tag for dev instances
 
 ./ec2-instances.py list|start|stop Prod|Stage|Dev|All
 
 By default is not allowed to stop production env and you can avoid that some instances be stopped or started by the script
 
 setting its instance id in "exclusions" array included in config.py
