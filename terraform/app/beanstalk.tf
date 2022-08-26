locals {
  eb_settings = [
    {
      namespace = "aws:elasticbeanstalk:cloudwatch:logs"
      name      = "StreamLogs"
      value     = var.stream_logs
    },
    {
      namespace = "aws:autoscaling:launchconfiguration"
      name      = "IamInstanceProfile"
      value     = "${var.eb_name}-ec2-role"
    },
    {
      namespace = "aws:autoscaling:launchconfiguration"
      name      = "DisableIMDSv1"
      value     = "true"
    },
    {
      namespace = "aws:elasticbeanstalk:managedactions"
      name      = "ManagedActionsEnabled"
      value     = "true"
    },
    {
      namespace = "aws:elasticbeanstalk:managedactions"
      name      = "PreferredStartTime"
      value     = "Wed:03:00"
    },
    {
      namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
      name      = "UpdateLevel"
      value     = "minor"
    },
    {
      namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
      name      = "InstanceRefreshEnabled"
      value     = "true"
    },
    {
      namespace = "aws:elasticbeanstalk:environment"
      name      = "ServiceRole"
      value     = "${var.eb_name}-service-role"
    },
    {
      namespace = "aws:elasticbeanstalk:environment"
      name      = "LoadBalancerType"
      value     = var.load_balancer_type
    },
    {
      name      = "SERVER_PORT"
      namespace = "aws:elasticbeanstalk:application:environment"
      value     = "5000"
    },
    {
      namespace = "aws:ec2:instances"
      name      = "InstanceTypes"
      value     = var.instance_types
    },
    # {
    #   namespace = "aws:ec2:vpc"
    #   name      = "VPCId"
    #   value     = aws_vpc.vpc.id
    # },
    {
      namespace = "aws:ec2:vpc"
      name      = "ELBScheme"
      value     = "public"
    },
    # {
    #   namespace = "aws:ec2:vpc"
    #   name      = "Subnets"
    #   value     = join(",", [aws_subnet.public_subnet1.id,aws_subnet.public_subnet2.id])
    # },
    # {
    #   namespace = "aws:ec2:vpc"
    #   name      = "ELBSubnets"
    #   value     = join(",", [aws_subnet.public_subnet1.id,aws_subnet.public_subnet2.id])
    # }
  ]
}

################################################################################
# Elastic Beanstalk Application
################################################################################

resource "aws_elastic_beanstalk_application" "eb_app" {
  name = var.eb_name
}

resource "aws_elastic_beanstalk_application_version" "eb_app_version" {
  application = aws_elastic_beanstalk_application.eb_app.name
  bucket      = aws_s3_bucket.s3_bucket_eb_app.id
  key         = aws_s3_object.s3_object_eb_app.id
  name        = var.app_version_name
}

################################################################################
# Elastic Beanstalk Environment
################################################################################

resource "aws_elastic_beanstalk_environment" "eb_env" {
  name                = var.eb_name
  application         = aws_elastic_beanstalk_application.eb_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.18 running Docker"
  version_label       = aws_elastic_beanstalk_application_version.eb_app_version.name

  dynamic "setting" {
    for_each = local.eb_settings
    content {
      namespace = setting.value.namespace
      name      = setting.value.name
      value     = setting.value.value
    }
  }
}

################################################################################
# Bucket for payload
################################################################################

resource "aws_s3_bucket" "s3_bucket_eb_app" {
  bucket = "${var.eb_name}"
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket_eb_app.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "s3_public_block" {
  bucket = aws_s3_bucket.s3_bucket_eb_app.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "s3_object_eb_app" {
  bucket = aws_s3_bucket.s3_bucket_eb_app.id
  key    = "beanstalk/eb_app"
  source = var.artefact_source
}

# resource "aws_s3_object" "s3_object_dockercfg" {
#   bucket = aws_s3_bucket.s3_bucket_eb_app.id
#   key    = "dockercfg"
#   source = var.dockercfg_source
# }

