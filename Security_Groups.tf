# ------------------------------------------------------
#        Security Groups for the Resources
# -----------------------------------------------------
# Security Group for EC2 Instance
resource "aws_security_group" "sg_wordpress" {
  name_prefix = "sg_wordpress"
  description = "Security Group for WordPress Project"
  vpc_id      = aws_vpc.vpc_wordpress.id

  ingress {
    description = "Allow ping "
    from_port   = 8
    to_port     = 8
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # My IP
  }
  ingress {
    description = "Liberate Inboud SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # My IP
  }
  ingress {
    description = "Liberate Inboud HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Liberate Inbound HTTPS"
    from_port   = 443 # HTTPS
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "RDS MYSQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Liberate all Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "EC2_security_group"
  }
}
# Security Group RDS MySql Database Instance
resource "aws_security_group" "mysql_rds_security_group" {
  name        = "mysql_rds_security_group"
  description = "Security Group for RDS MySql"
  vpc_id      = aws_vpc.vpc_wordpress.id
  tags = {
    Name = "RDS_security_group"
  }
}
resource "aws_security_group_rule" "allow_rds_inbound" {
  type                     = "ingress"
  security_group_id        = aws_security_group.mysql_rds_security_group.id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg_wordpress.id # Replace with the EC2 SG ID
}
resource "aws_security_group_rule" "allow_rds_outbound" {
  type                     = "egress"
  security_group_id        = aws_security_group.mysql_rds_security_group.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  #cidr_blocks              = ["0.0.0.0/24"]
  source_security_group_id = aws_security_group.sg_wordpress.id # Replace with the EC2 SG ID
}
