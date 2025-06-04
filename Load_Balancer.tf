
resource "aws_lb" "lb_wordpress_internet_facing" {          # Define the Resource and Name
  name               = "lb-wordpress-internet-facing"       # Name Tag
  internal           = false                                # Not to Internal Traffic
  load_balancer_type = "application"                        # Type of Load Balancer
  security_groups    = [aws_security_group.sg_wordpress.id] # Associate to a Security Group

  enable_deletion_protection = false      # Disable Accidental Exclusion

  enable_http2                     = true #  Enable  HTTP2 Protocol
  enable_cross_zone_load_balancing = true #  Enable High Availability among Avail Zones

  subnets = [aws_subnet.subnet_wordpress_public_01.id, aws_subnet.subnet_wordpress_public_02.id] # Define  the two Public Subnets.
}
