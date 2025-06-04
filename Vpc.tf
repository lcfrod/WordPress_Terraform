# ---------------------
#    VPC Definition
# ---------------------
# Definition of the main VPC. This VPC will host our four SUBNETS
resource "aws_vpc" "vpc_wordpress" {       
    cidr_block = "10.0.0.0/16"         # Defining the CIDR IP Blocks to be used
    enable_dns_hostnames = true        # Enable DNS Names.
    enable_dns_support = true          # Enable DNS Names.
     tags = {
       Name = "VPC Wordpress"           
  }
}