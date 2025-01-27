module "alb_5xx_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.8.0"
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  attributes = compact(concat(var.attributes, ["alb", "5xx"]))
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = module.alb_5xx_label.id
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_ELB_5XX"
  namespace           = "AWS/ApplicationELB"
  treat_missing_data  = "notBreaching"

  dimensions = {
    "LoadBalancer" = var.alb_arn_suffix
  }

  statistic         = "Sum"
  period            = "60"
  threshold         = var.threshold_elb_5xx
  alarm_description = "The number of HTTP 5XX server error codes that originate from the ${var.human_identifier} exceeded ${var.threshold_elb_5xx} in 60s. This count does not include any response codes generated by the targets. "
  alarm_actions     = var.alarm_actions
  ok_actions        = var.alarm_actions
}

module "backend_5xx_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.8.0"
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  attributes = compact(concat(var.attributes, ["backend", "5xx"]))
}

resource "aws_cloudwatch_metric_alarm" "backend_5xx" {
  alarm_name          = module.backend_5xx_label.id
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  treat_missing_data  = "notBreaching"

  dimensions = {
    "LoadBalancer" = var.alb_arn_suffix
  }

  statistic         = "Sum"
  period            = "60"
  threshold         = var.threshold_backend_5xx
  alarm_description = "The number of HTTP response codes generated by the ${var.human_identifier} targets exceeded ${var.threshold_backend_5xx} in 60s. This does not include any response codes generated by the load balancer. "
  alarm_actions     = var.alarm_actions
  ok_actions        = var.alarm_actions
}

module "target_connection_error_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.8.0"
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  attributes = compact(concat(var.attributes, ["target", "connection", "error"]))
}

resource "aws_cloudwatch_metric_alarm" "target_connection_error" {
  alarm_name          = module.target_connection_error_label.id
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "TargetConnectionErrorCount"
  namespace           = "AWS/ApplicationELB"
  treat_missing_data  = "notBreaching"

  dimensions = {
    "LoadBalancer" = var.alb_arn_suffix
  }

  statistic         = "Sum"
  period            = "60"
  threshold         = var.threshold_target_connection_error_count
  alarm_description = "${var.threshold_target_connection_error_count} connections were not successfully established between the load balancer and target."
  alarm_actions     = var.alarm_actions
  ok_actions        = var.alarm_actions
}

module "latency_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.8.0"
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  attributes = compact(concat(var.attributes, ["high", "latency"]))
}

resource "aws_cloudwatch_metric_alarm" "latency" {
  alarm_name          = module.latency_label.id
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  treat_missing_data  = "notBreaching"

  dimensions = {
    "LoadBalancer" = var.alb_arn_suffix
  }

  statistic         = "Average"
  period            = "60"
  threshold         = var.threshold_high_latency
  alarm_description = "The time elapsed, in seconds, after the request leaves the load balancer until a response from the target is received has exceeded an average of ${var.threshold_high_latency}s."
  alarm_actions     = var.alarm_actions
  ok_actions        = var.alarm_actions
}

module "unhealthy_hosts_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.8.0"
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  attributes = compact(concat(var.attributes, ["unhealthy", "hosts"]))
}

resource "aws_cloudwatch_metric_alarm" "unhealthy_hosts" {
  alarm_name          = module.unhealthy_hosts_label.id
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  treat_missing_data  = "notBreaching"

  dimensions = {
    "LoadBalancer" = var.alb_arn_suffix
  }

  statistic         = "Minimum"
  period            = "60"
  threshold         = var.threshold_unhealthy_host_count
  alarm_description = "The number of targets that are considered unhealthy exceeded ${var.threshold_unhealthy_host_count}."
  alarm_actions     = var.alarm_actions
  ok_actions        = var.alarm_actions
}

