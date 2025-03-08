##############################################################################
# SLZ VPC
##############################################################################

module "landing_zone" {
  # TODO: Update the slz version once https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone/pull/960 is merged.
  source           = "git::https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone//patterns//roks-quickstart?ref=v7.2.2"
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  prefix           = var.prefix
  resource_tags    = var.resource_tags
}
