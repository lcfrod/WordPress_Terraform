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
  region = "us-east-1"       #  North Virginia AWS Region 
  default_tags {             # Default Tags for all the Resources across this Project
    tags = {                     
        Environment = "Development"
        Owner = "AWS Especializacao"
        Project = "Project_01 WordPress AWS Migration"
        Architect = "Luiz Carlos Rodrigues"
    }
  }
}

# ---------------------
#    VPC Definition
# ---------------------
# Definition of the main VPC. This VPC will host our four SUBNETS
resource "aws_vpc" "vpc_wordpress" {       
    cidr_block = "10.0.0.0/16"         # Defining the CIDR IP Blocks to be used
    enable_dns_hostnames = true        # Enable DNS Names.
    enable_dns_support = true        # Enable DNS Names.
     tags = {
       Name = "VPC Wordpress"           
  }
}

# ---------------------------------
#              SUBNETS
# ---------------------------------
# Creating four subnets PUBLIC/PRIVATE in two Availability Zones
 
# Creating the 1st Public Subnet
resource "aws_subnet" "subnet_wordpress_public_01" {     # Public Subnet
  vpc_id     = aws_vpc.vpc_wordpress.id           
  availability_zone = "us-east-1a"           # Define Availability Zone - Region 1a. - North Virginia
  cidr_block = "10.0.1.0/24"              # Define CIDR Block.

  tags = {
    Name = "subnet_wordpress_public_01"              
  }
}

# Creating the 2nd  Public Subnet
resource "aws_subnet" "subnet_wordpress_public_02" {
  vpc_id     = aws_vpc.vpc_wordpress.id
  availability_zone = "us-east-1b"            # Define Availability Zone - Region 1a. - North Virginia
  cidr_block = "10.0.2.0/24"               # Define CIDR Block.
    
  tags = {
    Name = "subnet_wordpress_public_02"
  }
}


# Creating two PRIVATE Subnets to support the Back End Resources
# Creating the 1st Private  Subnet
resource "aws_subnet" "subnet_wordpress_private_01" {     #subnet_wordpress_private_01 É O NOME DA SUA SUBREDE, ESCOLHA UM DA SUA PREFERÊNCIA.
  vpc_id     = aws_vpc.vpc_wordpress.id           # Attach this Subnet to our VPC.
  availability_zone = "us-east-1a"           # Define Availability Zone - Region 1a - North Virginia
  cidr_block = "10.0.3.0/24"               # Define CIDR Blocks
  
  tags = {
    Name = "subnet_wordpress_private_01"              
  }
}

# Creasgting the 2nd Public Subnet
resource "aws_subnet" "subnet_wordpress_private_02" {
  vpc_id     = aws_vpc.vpc_wordpress.id
  availability_zone = "us-east-1b"           # Define Availability Zone - Region 1a - North Virginia
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "subnet_wordpress_private_02"              #AQUI VOCÊ DEFINE A TAG NAME QUE UTILIZARÁ NO RECURSO.
  }
}

# ------------------------------
#        Internet Gateway
# ------------------------------
resource "aws_internet_gateway" "igw_wordpress" {  # igw_wordpress É O NOME DO RECURSO PARA INTERNET GATEWAY QUE VAMOS UTILIZAR PARA DEIXAR NOSSA REDE EXTERNA PUBLICA PARA A INTERNET
  vpc_id = aws_vpc.vpc_wordpress.id               # AQUI VOCÊ DEFINE A QUAL VPC ESSA SUBREDE SERÁ ASSOCIADA. COLOQUE O NOME DA SUA VPC PRINCIPAL, NO MEU CASO, VPC_PROD.

  tags = {
    Name = "IGW WordPress"                         # AQUI VOCÊ DEFINE A TAG NAME QUE UTILIZARÁ NO RECURSO.
  }
}

# ----------------------
#  Routing Tables
# ----------------------

# -------------------------------
# Creating two Routing Tables 
# -------------------------------
resource "aws_route_table" "rt_wordpress_public" { 
  vpc_id = aws_vpc.vpc_wordpress.id                       # Associating Routing Table 01 to VPC

  tags = {
    Name = "rt_wordpress_public"           
  }
}
resource "aws_route_table" "rt_wordpress_private" { 
  vpc_id = aws_vpc.vpc_wordpress.id                      # Associating Routing Table 02 to VPC

  tags = {
    Name = "rt_wordpress_private"           
  }
}

# ---------------------------------------------------------------
# Associating the above created Routing Tables to Subnets
# --------------------------------------------------------------- 
resource "aws_route_table_association" "rt_assoc_wordpress_private_01" { 
  subnet_id      = aws_subnet.subnet_wordpress_private_01.id                 
  route_table_id = aws_route_table.rt_wordpress_private.id     
} 

resource "aws_route_table_association" "rt_assoc_wordpress_private_02" {
  subnet_id      = aws_subnet.subnet_wordpress_private_02.id
  route_table_id = aws_route_table.rt_wordpress_private.id
}


resource "aws_route_table_association" "rt_assoc_wordpress_public_01" { 
  subnet_id      = aws_subnet.subnet_wordpress_public_01.id                 
  route_table_id = aws_route_table.rt_wordpress_public.id     
} 

resource "aws_route_table_association" "rt_assoc_wordpress_public_02" {
  subnet_id      = aws_subnet.subnet_wordpress_public_02.id
  route_table_id = aws_route_table.rt_wordpress_public.id
}



#Routing for the access to Internet Gateway
resource "aws_route" "route_default_public_subnet_01" {  # # Creating Default Route 
  route_table_id         = aws_route_table.rt_wordpress_public.id  
  destination_cidr_block = "0.0.0.0/0"   
  gateway_id = aws_internet_gateway.igw_wordpress.id   
}

resource "aws_route" "route_default_public_subnet_02" {  # Creating Default Route 
  route_table_id         = aws_route_table.rt_wordpress_public.id 
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw_wordpress.id   
}

# -------------------------------------------------------
#        Network ACL for Public and Private Subnets
# -----------------------------------------------------
resource "aws_network_acl" "acl_wordpress_public" {
  vpc_id = aws_vpc.vpc_wordpress.id  
  subnet_ids   = [aws_subnet.subnet_wordpress_public_01.id, aws_subnet.subnet_wordpress_public_02.id]

  # Inbound Rules
  ingress {                     
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22            # Port SSH(22)
    to_port    = 22
   }
  ingress {           
    rule_no    = 110
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80           # Port  HTTP(80)
    to_port    = 80
   }
  ingress {        
    rule_no    = 120
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443        # Port  HTTPS(443)
    to_port    = 443
   }
  ingress {            
    rule_no    = 300
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024        # Port  HTTPS(443)
    to_port    = 65535
   }
# Outbond Rules
egress {                  
    rule_no    = 100
    protocol   = "all"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
egress {                  
    rule_no    = 300        # Portas Efêmeras
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024       # Portas Efêmeras
    to_port    = 65535
  }
 
  tags = {
    Name = "acl_wordpress_public"
  }
}

resource "aws_network_acl" "acl_wordpress_private" {
  vpc_id = aws_vpc.vpc_wordpress.id  
  subnet_ids   = [aws_subnet.subnet_wordpress_public_01.id, aws_subnet.subnet_wordpress_public_02.id]

  ingress {                    # Inbound Rule
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 3306            # Port MySql(3306)
    to_port    = 3306
   }
  

  ingress {          # Outbound -   
    rule_no    = 200
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024        # Port  HTTPS(443)
    to_port    = 65535
   }

  egress {                 # Outbound Rules / Portas Efêmeras
    rule_no    = 300
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  tags = {
    Name = "acl_wordpress_private"
  }
}


# -------------------------------------------------------
#        Security Group
# -----------------------------------------------------
resource "aws_security_group" "sg_wordpress" { 
  name_prefix = "sg_wordpress"               
  description = "Security Group for WordPress Project"
  vpc_id = aws_vpc.vpc_wordpress.id                     

 ingress {
    description = "Allow ping "
    from_port = 8      
    to_port   = 8
    protocol  = "icmp"
    cidr_blocks = ["0.0.0.0/0"]     # My IP
 }
 ingress {
    description = "Liberate Inboud SSH"
    from_port = 22      
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]     # My IP
  }

  ingress {
    description = "Liberate Inboud HTTP"
    from_port = 80      
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   
  }

  ingress {
    description = "Liberate Inbound HTTPS"
    from_port = 443     # HTTPS
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
    
  egress {
    description = "Liberate Outbound"
    from_port = 0     # HTTPS
    to_port   = 0
    protocol  = -1
    cidr_blocks = ["0.0.0.0/0"]  
  }

}

resource "aws_lb" "lb_wordpress_internet_facing" {   #AQUI VOCÊ DEFINE O RECURSO E O NOME DO ELB
  name               = "lb-wordpress-internet-facing"  #AQUI VOCÊ DEFINE O TAG NAME DO RECURSO
  internal           = false              #AQUI DEFINIMOS QUE NÃO SERÁ DE TRÁFEGO INTERNO
  load_balancer_type = "application"      #AQUI VOCÊ DEFINE O TIPO DE ELB QUE SERÁ CRIADO
  security_groups   = [aws_security_group.sg_wordpress.id]    #AQUI VOCÊ ASSOCIA O SG CRIADO ACIMA AO ELB

  enable_deletion_protection = false  # ESSE ITEM HABILITA A PROTEÇÃO CONTRA EXCLUSÃO ACIDENTAL

  enable_http2       = true   #AQUI VOCÊ HABILITA O PROTOCOLO HTTP2
  enable_cross_zone_load_balancing = true #AQUI VOCÊ HABILITA A ALTA DISPONIBILIDADE ENTRE ZONAS AWS

  subnets = [aws_subnet.subnet_wordpress_public_01.id, aws_subnet.subnet_wordpress_public_02.id]  #AQUI VOCÊ ADICIONA SUAS SUB REDES ZONAS A E B. COMO É PARA A INTERNET, PRECISA ADICIONAR AS DUAS SUBREDES PÚBLICAS.
}

#-------------------------------------
# Creating SSH Key Pair
# ------------------------------------
# 1)Commands to generate keys in the file key_wordpress/ key_wordpress.pub
#  ssh-keygen -t rsa -b 4096
#  Save in the Pub and Priv Keys in ./key_wordpres
#  Convert Priv key to ppk :   puttygen key_wordpress  -O private  -o key_wordpress.ppk
# 

resource "aws_key_pair" "key_wordpress" {
  key_name   =   "key_wordpress"
  public_key =   "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCchfKKtbc9k4YcyHHX2PEkt10G4HlYQ0FkdkUBIUlTijXktdoVTfVEPZJLXiN5tboxS4LjUD2NaLbp0L3z8MjlyhqF4YD+Lui+gG8M6lKLrqbjguPePM39wcmFmGu2S/yQTfKLlMrpKszeBwxcDh1tE1ZXHxxphWurhqXp5Kfq1BrdE6gmWl49AfV9mixVHparlGXvDf8Sz1qAKSv0SuMDxTbMfxLUCakIO+u6b6z0sT7Gpp+G3Yv6T0lp0D48oXHwNpQaikyFa07T2RnHCkf67IdiCuhxfekEpzX3d7zb2xY6Hf+H2ZSLbujOQqa5TbxxAHCyXOEpPvBXS+UIa8qUYb796UWOyxVSyf1c20ItrExq/+rSVvhenQLfr6db5C7IQUU4VdfhlTbmAZ0Xue6zY7iMGX3ZaOc1fj4hRQT9E3cjmd50qKXpTVddIimTPXMTqEPTJKxdugdFNBy74nZUqn6ZNtdFeH6xCChJdHcoIIL3S71SLy5fqwWff1C4C05VzYOWoRpE6+vYXBSStBkkYTWa4y5CdkFNR5RYOGphckc3TZGcsZTEUokZKigHCOZSJxeB2nBoYiIwb8a9fRry3AIgPdV6f3tPWG0e0DrAExZxEB1R2iT6c3Vk0JqMgAej76LObJFmeCho8V34aHninClpoovi03i94eFAGT9lYw== lcfrod@lcfrod-IdeaPad"
#  public_key =  file("key_wordpress.pub")
  tags = {
      Name  = "WordPress Key Pair"
  }
}

#-------------------------------------
# Create IAM Role
# ------------------------------------

resource "aws_iam_role" "ec2-s3-read" {
  name = "002-ec2-s3-read"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "ec2_s3_read_policy_attach" {
 #name = "ec2_s3_read_policy_attach"
  role   = aws_iam_role.ec2-s3-read.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2-s3-read.name
}

#-------------------------------------
# Creating AWS EC2 Instance
# ------------------------------------
resource "aws_instance" "ec2_wordpress" {
    ami = "ami-0f9de6e2d2f067fca"     # Ubuntu 22.04 - AMD64
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = aws_key_pair.key_wordpress.key_name
    security_groups = ["${aws_security_group.sg_wordpress.id}"]
    subnet_id   = "${aws_subnet.subnet_wordpress_public_01.id}"
    iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
    associate_public_ip_address = true
    user_data  = filebase64("./ec2_user_data_script.sh")
    #user_data = "${file(ec2_user_data_script.sh)}"

    tags = {
      Name  = "EC2_WordPress"
      OS    = "Ubuntu 22.04"
 
    }

   depends_on = [
         aws_key_pair.key_wordpress
    ]



  
}

