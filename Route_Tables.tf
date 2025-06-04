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
