#-------------------------------------
# Creating AWS EC2 Instance
# ------------------------------------
resource "aws_instance" "ec2_wordpress" {
  ami                         = "ami-0f9de6e2d2f067fca" # Ubuntu 22.04 - AMD64
  instance_type               = "t2.micro"
  availability_zone           = "us-east-1a"
  key_name                    = aws_key_pair.key_wordpress.key_name
  security_groups             = ["${aws_security_group.sg_wordpress.id}"]
  subnet_id                   = aws_subnet.subnet_wordpress_public_01.id
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  associate_public_ip_address = true
 #user_data                   = filebase64("./ec2_user_data_script.sh")  # For CodeDeploy
  user_data                   = filebase64("./ec2_wp_aws_user_data.sh")  # For WordPress


  tags = {
    Name = "EC2_WordPress"
    OS   = "Ubuntu 22.04"

  }

  depends_on = [
    aws_key_pair.key_wordpress
  ]

}

