# Create RDS MySql databas  for WordPress backend
resource "aws_db_instance" "default" {
  identifier           = "wordpress-database"
  allocated_storage    = 10
  db_name              = "wordpressdb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  #vpc_security_group_ids = [aws_security_group.sg_wordpress.id]
  vpc_security_group_ids = ["${aws_security_group.mysql_rds_security_group.id}"]
  db_subnet_group_name   = aws_db_subnet_group.wp_db_wordpress_subnet_grp.name
  username               = "admin"
  password               = "admin#123"

}


# Configure the MySQL provider based on the outcome of
# creating the aws_db_instance.
provider "mysql" {
  endpoint = aws_db_instance.default.endpoint
  username = aws_db_instance.default.username
  password = aws_db_instance.default.password
}

#resource "mysql_user" "wordpress_user" {
#  user     = "wordpuser" # Replace with your desired username
#  host     = "%"         # or specific IP if you need to restrict
#  password = "word#7890" # Replace with your user password
#  db_name    = "wordpressdb"
#  privileges = ["SELECT", "INSERT", "UPDATE", "DELETE", "CREATE", "DROP", "ALTER"]
#}

#resource "mysql_grant" "wordpress_user_grant" {
#  user       = "${aws_db_instance.default.username}"
#  host       = "${aws_db_instance.default.endpoint}"
#  database   = "${aws_db_instance.default.db_name}"
#  privileges = ["SELECT", "INSERT", "UPDATE", "DELETE", "CREATE", "DROP", "ALTER"]
#  depends_on = [aws_db_instance.default]
#}

output "rds_address" {
  value = aws_db_instance.default.address
}
