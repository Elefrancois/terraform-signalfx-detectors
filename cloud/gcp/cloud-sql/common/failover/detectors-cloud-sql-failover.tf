resource "signalfx_detector" "failover_unavailable" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] GCP Cloud SQL failover"

  program_text = <<-EOF
    signal = data('database/available_for_failover', ${module.filter-tags.filter_custom})${var.failover_unavailable_aggregation_function}.${var.failover_unavailable_transformation_function}(over='${var.failover_unavailable_transformation_window}').publish('signal')
    detect(when(signal < ${var.failover_unavailable_threshold_warning})).publish('WARN')
EOF

  rule {
    description           = "is unavailable"
    severity              = "Warning"
    detect_label          = "WARN"
    disabled              = coalesce(var.failover_unavailable_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.failover_unavailable_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }
}
