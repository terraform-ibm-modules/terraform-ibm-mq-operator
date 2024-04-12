##############################################################################
# SLZ VPC
##############################################################################

module "landing_zone" {
  source                 = "git::https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone//patterns//roks-quickstart//module?ref=v5.20.3"
  region                 = var.region
  prefix                 = var.prefix
  tags                   = var.resource_tags
  enable_transit_gateway = false
  add_atracker_route     = false
}
