variable "human_identifier" {
  description = "Identifier for the load balancer used in alarm descriptions"
}

variable "alb_arn_suffix" {
  description = "Specify the load balancer as follows: app/load-balancer-name/1234567890123456 (the final portion of the load balancer ARN)."
}

variable "alarm_actions" {
  type = "list"
}

variable "threshold_backend_5xx" {
  default = 1
}
variable "threshold_elb_5xx" {
  default = 1
}
variable "threshold_high_latency" {
  default = 0.05
}
variable "threshold_target_connection_error_count" {
  default = 1
}

variable "threshold_unhealthy_host_count" {
  default = 1
}
