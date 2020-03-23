resource "signalfx_detector" "heartbeat" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Kubernetes node heartbeat"

  program_text = <<-EOF
		from signalfx.detectors.not_reporting import not_reporting
		signal = data('machine_memory_bytes', ${module.filter-tags.filter_custom})
		not_reporting.detector(stream=signal, resource_identifier=['kubernetes_node'], duration='${var.heartbeat_timeframe}').publish('CRIT')
	EOF

  rule {
    description           = "has not reported in ${var.heartbeat_timeframe}"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.heartbeat_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.heartbeat_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} on {{{dimensions}}}"
  }
}

resource "signalfx_detector" "ready" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Kubernetes node ready state"

  program_text = <<-EOF
		signal = data('kubernetes.node_ready', ${module.filter-tags.filter_custom})${var.ready_aggregation_function}.${var.ready_transformation_function}(over='${var.ready_transformation_window}').publish('signal')
		detect(when(signal < ${var.ready_threshold_critical})).publish('CRIT')
		detect(when(signal < ${var.ready_threshold_warning}) and when(signal >= ${var.ready_threshold_critical})).publish('WARN')
	EOF

  rule {
    description           = "is too high >= ${var.ready_threshold_critical}"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.ready_disabled_critical, var.ready_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.ready_notifications_critical, var.ready_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }

  rule {
    description           = "is too high >= ${var.ready_threshold_warning}"
    severity              = "Warning"
    detect_label          = "WARN"
    disabled              = coalesce(var.ready_disabled_warning, var.ready_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.ready_notifications_warning, var.ready_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }
}

resource "signalfx_detector" "volume_space" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Kubernetes node volume space usage"

  program_text = <<-EOF
		A = data('kubernetes.volume_available_bytes', ${module.filter-tags.filter_custom})${var.volume_space_aggregation_function}
		B = data('kubernetes.volume_capacity_bytes', ${module.filter-tags.filter_custom})${var.volume_space_aggregation_function}
		signal = (((B-A)/B)*100).${var.volume_space_transformation_function}(over='${var.volume_space_transformation_window}').publish('signal')
		detect(when(signal > ${var.volume_space_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.volume_space_threshold_warning}) and when(signal < ${var.volume_space_threshold_critical})).publish('WARN')
	EOF

  rule {
    description           = "is too high > ${var.volume_space_threshold_critical}"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.volume_space_disabled_critical, var.volume_space_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.volume_space_notifications_critical, var.volume_space_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }

  rule {
    description           = "is too high > ${var.volume_space_threshold_warning}"
    severity              = "Warning"
    detect_label          = "WARN"
    disabled              = coalesce(var.volume_space_disabled_warning, var.volume_space_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.volume_space_notifications_warning, var.volume_space_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }
}