data "aws_iam_policy" "example" {
  name = "AmazonSSMFullAccess"
}

resource "aws_iam_role" "kubernetes" {
  name                = "${var.project}-ec2-ssm-role"
  managed_policy_arns = [data.aws_iam_policy.example.arn]
  assume_role_policy  = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_iam_instance_profile" "example_instance_profile" {
  name = "${var.project}-instance-profile"
  role = aws_iam_role.kubernetes.name
}
