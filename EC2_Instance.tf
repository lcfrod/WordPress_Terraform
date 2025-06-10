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
  #user_data = filebase(templatefile("./ec2_user_data_script.sh")); { rds_endpoint =  aws_db_instance.default.endpoint })
  #user_data = filebase64(templatefile("${path.module}/ec2_user_data_script.sh", { rds_endpoint = aws_db_instance.default.endpoint }))
  #user_data = templatefile("${path.module}/userdata.sh", { rds_endpoint = var.rds_endpoint })
  user_data = base64encode(templatefile("./ec2_user_data_script.sh", {
    rds_address  = aws_db_instance.default.address
    rds_password = aws_db_instance.default.password
    #    DB_USER           = var.DB_USER
    #    DB_PASSWORD_PARAM = var.DB_PASSWORD_PARAM
    #    DB_PORT           = var.DB_PORT
    #    DB_NAME           = var.DB_NAME
  }))


  tags = {
    Name = "EC2_WordPress"
    OS   = "Ubuntu 22.04"

  }

  depends_on = [
    aws_key_pair.key_wordpress
  ]


}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance."
  value       = ["${aws_instance.ec2_wordpress.*.public_ip}"]
}
