resource "aws_iam_user" "mlops_user" {
  name = "mlops-intro-user-${random_string.random_id.result}"
  path = "/system/"
}

resource "aws_iam_access_key" "access_key" {
  user = aws_iam_user.mlops_user.name
}

resource "aws_iam_user_policy" "lb_ro" {
  name = "mlops-intro-user-profile-${random_string.random_id.result}"
  user = aws_iam_user.mlops_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}