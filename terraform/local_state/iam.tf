# Create the IAM group
resource "aws_iam_group" "kops_group" {
  name = "kops"
}

# Attach the required policies to the group
resource "aws_iam_group_policy_attachment" "kops_ec2_policy_attachment" {
  group      = aws_iam_group.kops_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "kops_route53_policy_attachment" {
  group      = aws_iam_group.kops_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_group_policy_attachment" "kops_s3_policy_attachment" {
  group      = aws_iam_group.kops_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group_policy_attachment" "kops_iam_policy_attachment" {
  group      = aws_iam_group.kops_group.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_group_policy_attachment" "kops_vpc_policy_attachment" {
  group      = aws_iam_group.kops_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_group_policy_attachment" "kops_sqs_policy_attachment" {
  group      = aws_iam_group.kops_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_group_policy_attachment" "kops_eventbridge_policy_attachment" {
  group      = aws_iam_group.kops_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
}

# Create the IAM user
resource "aws_iam_user" "kops_user" {
  name = "kops"
}

# Add the user to the group
resource "aws_iam_user_group_membership" "kops_group_membership" {
  user  = aws_iam_user.kops_user.name
  groups = [aws_iam_group.kops_group.name]
}

# Create an access key for the user
resource "aws_iam_access_key" "kops_access_key" {
  user = aws_iam_user.kops_user.name
}
