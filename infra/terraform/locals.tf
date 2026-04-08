locals {
  common_tags = {
    Project   = var.project_name
    ManagedBy = "terraform"
  }

  name_prefix = var.project_name
}