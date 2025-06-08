# Create RDS MySql databas  for WordPress backend
resource "aws_db_instance" "default" {
  identifier             = "wordpress-database"
  allocated_storage      = 10
  db_name                = "wordpressdb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  #vpc_security_group_ids = [aws_security_group.sg_wordpress.id]
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  db_subnet_group_name   = aws_db_subnet_group.wp_db_wordpress_subnet_grp.name
  username               = "admin"
  password               = "admin#123"

}
 
