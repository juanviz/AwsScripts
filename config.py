aws_access_key_id     = ''
aws_secret_access_key = ''
# These tags have to match with values of a Tag called "Env" in your instances
TagDev = ["bq-web-dev","bq-web-qa",]
# This array includes all of the values used in Tag "Env" for list, stop or start the whole platform
TagAll = ["bq-web-dev","bq-web-qa","bq-web-integration","bq-web-prod",]
TagStage = ["bq-web-integration",]
TagProd = ["bq-web-prod",]
# If you want to avoid that some instances will be stopped or started by this script
# set the instance id up in the following array and will not be stopped or started 
exclusions=["i-51a02a31",]
