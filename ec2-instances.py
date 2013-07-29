#!/usr/bin/env python
# author: Juan Vicente Herrera 
# juanvicenteherrera.eu
# requisites: boto python module installed
# sudo pip install boto
# script that start, stop or list the instances of an environment
# All of the instances of an environment has to have a tag called "Env" with one of the values defined in the config.py file
# Example of usage ./ec2-instances.py stop Dev
# Dev is the value of Tag "Env" in all of the instances that compose dev environment and is defined in config.py
# as the value of Env Tag for dev instances
# ./ec2-instances.py list|start|stop Prod|Stage|Dev|All
# By default is not allowed to stop production env and you can avoid that some instances be stopped or started by the script
# setting its instance id in "exclusions" array included in config.py


 
from boto.ec2 import EC2Connection
import sys
import re
import config
import argparse
from optparse import OptionParser, make_option


csv_file = open('instances.csv','w+')

def main():
	
	print ("%s"%(str(sys.argv[1])))
	if (len(sys.argv) < 3):
    		#parser = OptionParser()
			#parser.add_option('--var', help='Choose a valid option; Prod,Stage,Dev,All; Example of usage:')
			#(options, args) = parser.parse_args()
			parser = argparse.ArgumentParser()
			parser.add_argument("Prod|Stage|Dev|All", help="environment that you want to get all of the instances")
			parser.add_argument("list|start|stop", help="action that you want to execute in all of the servers of an environment")

			args = parser.parse_args()
			#print args.env
	else:
		if (str(sys.argv[1]) == "stop" and str(sys.argv[2]) == "Prod"):
			print "Invalid option. Not allow to shutdown Production environment without authorization"
			print "list|start|stop are the only valid values"
			#print (str(sys.argv[1])
			sys.exit(2)	
		if (str(sys.argv[1]) != "list" and str(sys.argv[1]) != "start" and str(sys.argv[1]) != "stop"):
			print "Invalid option."
			print "list|start|stop are the only valid values"
			#print (str(sys.argv[1])
			sys.exit(2)			
		if (str(sys.argv[2]) != "Prod" and str(sys.argv[2]) != "Dev" and str(sys.argv[2]) != "Stage" and str(sys.argv[2]) != "All"):
			print "Invalid option."
			print "Prod|Stage|Dev|All are the only valid values"
			sys.exit(2)	

    	connection = EC2Connection(aws_access_key_id=config.aws_access_key_id,aws_secret_access_key=config.aws_secret_access_key)
    	process_instance_list(connection)
    	csv_file.close()

def process_instance_list(connection):
    map(build_instance_list,connection.get_all_instances())
 
def build_instance_list(reservation):
    map(write_instances,reservation.instances)
 
def write_instances(instance):
    regexes_es=config.exclusions
    if (str(sys.argv[2])=="Prod"):
    	regexes = config.TagProd

    	
    elif (str(sys.argv[2])=="Stage"):
    	regexes = config.TagStage

    		
    elif (str(sys.argv[2])=="Dev"):
		regexes = config.TagDev
    elif (str(sys.argv[2])=="All"):
    	regexes = config.TagAll

    if (instance.tags.get('Env') is not None):
    	if instance.tags.get('Env')  in regexes:
            csv_file.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n"%(instance.tags.get('Name'),instance.private_ip_address,instance.key_name,instance.id,instance.instance_type,instance.public_dns_name,instance.state,instance.placement,instance.architecture, instance.platform))
            print ("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n"%(instance.tags.get('Name'),instance.private_ip_address,instance.key_name,instance.id,instance.instance_type,instance.public_dns_name, instance.state,instance.placement,instance.architecture, instance.platform))
            if instance.id in regexes_es:
                print "Excluido"
            else:  
                print "en marcha"  
                if (str(sys.argv[1])=="start"):
                    instance.start()
                    print "starting"
                elif (str(sys.argv[1])=="stop"):
                    print instance.id
                    instance.stop()      
                    print "stopping"
    	                                      
    csv_file.flush()
        
if __name__=="__main__":
	 main()	
	

