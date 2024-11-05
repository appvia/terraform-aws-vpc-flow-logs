variable "name" {
  description = "Name used for the cloudwatch group and role"
  type        = string
}

variable "retention_in_days" {
  description = "Number of days to retain flow logs"
  default     = 365
  type        = number
}

variable "traffic_type" {
  description = "Type of traffic to capture. Valid values: ACCEPT,REJECT, ALL"
  default     = "ALL"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to enable flow logs for"
  type        = string
}