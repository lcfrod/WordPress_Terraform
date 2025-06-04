# -------------------------------------------------------
#        Network ACL for Public and Private Subnets
# -----------------------------------------------------
resource "aws_network_acl" "acl_wordpress_public" {
  vpc_id     = aws_vpc.vpc_wordpress.id
  subnet_ids = [aws_subnet.subnet_wordpress_public_01.id, aws_subnet.subnet_wordpress_public_02.id]

  # Inbound Rules
  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22 # Port SSH(22)
    to_port    = 22
  }
  ingress {
    rule_no    = 110
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80 # Port  HTTP(80)
    to_port    = 80
  }
  ingress {
    rule_no    = 120
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443 # Port  HTTPS(443)
    to_port    = 443
  }
  ingress {
    rule_no    = 300
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024 # Port  HTTPS(443)
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
    rule_no    = 300 # Portas Efêmeras
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024 # Portas Efêmeras
    to_port    = 65535
  }

  tags = {
    Name = "acl_wordpress_public"
  }
}

resource "aws_network_acl" "acl_wordpress_private" {
  vpc_id     = aws_vpc.vpc_wordpress.id
  subnet_ids = [aws_subnet.subnet_wordpress_public_01.id, aws_subnet.subnet_wordpress_public_02.id]

  ingress { # Inbound Rule
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 3306 # Port MySql(3306)
    to_port    = 3306
  }

  ingress { # Outbound -   
    rule_no    = 200
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024 # Port  HTTPS(443)
    to_port    = 65535
  }

  egress { # Outbound Rules / Portas Efêmeras
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

