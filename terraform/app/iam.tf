################################################################################
# IAM
################################################################################

data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "elb_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["elasticbeanstalk.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = ["elasticbeanstalk"]
    }
  }
}

data "aws_iam_policy" "WebTier" {
  name = "AWSElasticBeanstalkWebTier"
}

data "aws_iam_policy" "MulticontainerDocker" {
  name = "AWSElasticBeanstalkMulticontainerDocker"
}

data "aws_iam_policy" "WorkerTier" {
  name = "AWSElasticBeanstalkWorkerTier"
}

data "aws_iam_policy" "EnhancedHealth" {
  name = "AWSElasticBeanstalkEnhancedHealth"
}

data "aws_iam_policy" "ManagedUpdatesCustomerRolePolicy" {
  name = "AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy"
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.eb_name}-${random_string.random_id.result}-ec2-role"
  role = aws_iam_role.ec2-role.name
}

resource "aws_iam_role" "ec2-role" {
  name                = "${var.eb_name}-${random_string.random_id.result}-ec2-role"
  assume_role_policy  = data.aws_iam_policy_document.ec2_assume_role_policy.json
  managed_policy_arns = [data.aws_iam_policy.WebTier.arn, data.aws_iam_policy.MulticontainerDocker.arn, data.aws_iam_policy.WorkerTier.arn]
}
resource "aws_iam_role" "service-role" {
  name                = "${var.eb_name}-${random_string.random_id.result}-service-role"
  assume_role_policy  = data.aws_iam_policy_document.elb_assume_role_policy.json
  managed_policy_arns = [data.aws_iam_policy.EnhancedHealth.arn, data.aws_iam_policy.ManagedUpdatesCustomerRolePolicy.arn]
}