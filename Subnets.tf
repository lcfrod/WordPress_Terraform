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
