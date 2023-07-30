terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "0.2.0-beta2"
    }
  }
}

provider "btp" {
  globalaccount = var.globalaccount_subdomain
  username      = var.admin_user
  password      = var.admin_password
}

resource "btp_subaccount" "subaccount" {
  name        = var.subaccount
  subdomain   = "${var.subaccount}"
  region      = "us10"
  description = "btp-entitlement-sample"
}


module "sap-btp-entitlements" {
  source = "aydin-ozcan/sap-btp-entitlements"
  subaccount = btp_subaccount.subaccount.id
  entitlements = {
    "xsuaa"                  = ["application"],
    "kymaruntime"            = ["trial=1"],
    "APPLICATION_RUNTIME"    = ["MEMORY=1"],  # Cloud Foundry and Kyma needs to specify amount even if it is 1
    "destination"            = ["lite"],
    "html5-apps-repo"        = ["app-host", "app-runtime"],    
    "hana-cloud-trial"       = ["hana"],
    "hana-cloud-tools-trial" = ["tools"],
    "hana"                   = ["hdi-shared", "schema", "sbss", "securestore"],
  }
}
