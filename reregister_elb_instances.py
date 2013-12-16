import boto
import config
from boto import regioninfo
from boto import ec2

elb_region = boto.regioninfo.RegionInfo(
    name='eu-west-1', 
    endpoint='eu-west-1.elasticloadbalancing.amazonaws.com')

elb_connection = boto.connect_elb(
    aws_access_key_id=config.aws_access_key_id, 
    aws_secret_access_key=config.aws_secret_access_key, 
    region=elb_region)

ec2_region = ec2.get_region(
    aws_access_key_id=config.aws_access_key_id, 
    aws_secret_access_key=config.aws_secret_access_key, 
    region_name='eu-west-1')

ec2_connection = boto.ec2.connection.EC2Connection(
    aws_access_key_id=config.aws_access_key_id, 
    aws_secret_access_key=config.aws_secret_access_key, 
    region=ec2_region)

load_balancer = elb_connection.get_all_load_balancers(load_balancer_names=['staging-books','stagingBo-ElasticL-1D6ABW6PJM2XU'])
for elb in load_balancer:
    instance_ids = [ instance.id for instance in elb.instances ]
    print "Instances %s deattached of Load Balancer %s" %(instance_ids,elb.name) 
    elb.deregister_instances(instance_ids)
    elb.register_instances(instance_ids)
