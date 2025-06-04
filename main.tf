# ############################################################################
# Project 01 - WordPress Migration
# Created by : Luiz Carlos Rodrigues (lcfrod@hotmail.com)
# Date : 
# 1) AWS_ACCESS_KEY_ID and  AWS_SECRET_ACCESS_KEY are provided by 
#    the Environment Variables 
# 2) Working AWS Region is hardcoded
# Last Update - 25/05/2025 - GitHub  10:20 h
# Updated SSH Pub Key
# #############################################################################
# Define AWS as the Provider

provider "aws" {
  region = "us-east-1" #  North Virginia AWS Region 
  default_tags {       # Default Tags for all the Resources across this Project
    tags = {
      Environment = "Development"
      Owner       = "AWS Especializacao"
      Project     = "Project_01 WordPress AWS Migration"
      Company     = "Acme Corporation"
      Architect   = "Luiz Carlos Rodrigues"
    }
  }
}

# End of Code

