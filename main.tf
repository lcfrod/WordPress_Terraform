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

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    mysql = {
      source = "petoju/mysql"
      version = "~> 3.0.72"
    }
    
  }
}
 
# End of Code

