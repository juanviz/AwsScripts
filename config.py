aws_access_key_id='xxxxxxxxxxxx'
aws_secret_access_key='xxxxxxxxxxxxxxxxxxxxxx'
# These tags have to match with values of a Tag called "Env" in your instances
TagDev = ["Dev",]
TagStage = ["Stage",]
TagProd = ["Prod",]
# This array includes all of the values used in Tag "Env" for list, stop or start the whole platform
TagAll = ["Dev,Prod, Stage,"]
# If you want to avoid that some instances will be stopped or started by this script
# set the instance id up in the following array and will not be stopped or started 
exclusions=["i-xxxxxxxxxxx",]
