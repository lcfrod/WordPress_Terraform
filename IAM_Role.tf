#-------------------------------------
# Create IAM Role
# ------------------------------------
resource "aws_iam_role" "ec2-s3-read" {
  name = "002-ec2-s3-read"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "ec2_s3_read_policy_attach" {
  #name = "ec2_s3_read_policy_attach"
  role       = aws_iam_role.ec2-s3-read.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2-s3-read.name
}

## End of Code
