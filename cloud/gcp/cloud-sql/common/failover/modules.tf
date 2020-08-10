module "filter-tags" {
  source = "github.com/claranet/terraform-signalfx-detectors.git//common/filter-tags"

  filter_defaults        = "filter('gcp_tag_env', '${var.environment}') and filter('gcp_tag_sfx_monitored', 'true') and not(filter('database_id', '*-replica*'))"
  filter_custom_includes = var.filter_custom_includes
  filter_custom_excludes = var.filter_custom_excludes
}
