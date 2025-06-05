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

# Security group for RDS
resource "aws_security_group" "RDS_allow_rule" {
  vpc_id = aws_vpc.vpc_wordpress.id                     
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.sg_wordpress.id}"]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "RDS_allow_rule ec2"
  }
}