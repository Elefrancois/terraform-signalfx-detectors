# Global

variable "environment" {
  description = "Infrastructure environment"
  type        = string
}

# SignalFx module specific

variable "notifications" {
  description = "Notification recipients list for every detectors"
  type        = list
}

variable "prefixes" {
  description = "Prefixes list to prepend between brackets on every monitors names before environment"
  type        = list
  default     = []
}

variable "filter_custom_includes" {
  description = "List of tags to include when custom filtering is used"
  type        = list
  default     = []
}

variable "filter_custom_excludes" {
  description = "List of tags to exclude when custom filtering is used"
  type        = list
  default     = []
}

variable "detectors_disabled" {
  description = "Disable all detectors in this module"
  type        = bool
  default     = false
}

# Failover_unavailable detectors

variable "failover_unavailable_disabled" {
  description = "Disable all alerting rules for failover_unavailable detector"
  type        = bool
  default     = null
}

variable "failover_unavailable_notifications" {
  description = "Notification recipients list for every alerting rules of failover_unavailable detector"
  type        = list
  default     = []
}

variable "failover_unavailable_aggregation_function" {
  description = "Aggregation function and group by for failover_unavailable detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ""
}

variable "failover_unavailable_transformation_function" {
  description = "Transformation function for failover_unavailable detector (mean, min, max)"
  type        = string
  default     = "max"
}

variable "failover_unavailable_transformation_window" {
  description = "Transformation window for failover_unavailable detector (i.e. 5m, 20m, 1h, 1d)"
  type        = string
  default     = "10m"
}

variable "failover_unavailable_threshold_warning" {
  description = "Warning threshold for failover_unavailable detector"
  type        = number
  default     = 1
}
