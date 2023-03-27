terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.16"
    }
  }

  backend "s3" {
    bucket = "cloudwatch-project"
    key    = "sharon_levi.pem"
    region = "us-east-1"
    workspace_key_prefix = "tf_alarm"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.region
  assume_role {
    role_arn     = "arn:aws:iam::700935310038:role/terraform-jenkins-roles"
    session_name = "SESSION_NAME"
  }
}

resource "aws_sns_topic" "alarms_sns" {
  name = "alarm-sns-topic-${var.workspace}"
}

resource "aws_cloudwatch_metric_alarm" "alarm1" {
  alarm_name                = "alarm1-${var.workspace}-${var.region}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  alarm_actions = var.workspace == ["prod" && var.sendMail ? [aws_sns_topic.alarms_sns.arn] : []]
  dimensions = {
    InstanceId = 'i-06d3af03a1419454b'
  }
}


resource "aws_cloudwatch_metric_alarm" "alarm2" {
  alarm_name                = "alarm1-${var.workspace}-${var.region}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  alarm_actions = var.workspace == ["prod" && var.sendMail ? [aws_sns_topic.alarms_sns.arn] : []]
  dimensions = {
    InstanceId = 'i-06d3af03a1419454b'
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm3" {
  count = var.includeAlarm3inRegion ? 1 : 0
  alarm_name                = "alarm3-${var.workspace}-${var.region}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  alarm_actions = var.workspace == ["prod" && var.sendMail ? [aws_sns_topic.alarms_sns.arn] : []]
  dimensions = {
    InstanceId = 'i-06d3af03a1419454b'
  }
}

