terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
    }
  }
}

locals {
  parsed_entitlements_data = flatten([
    for service, plans in var.entitlements : [
      for plan in plans : {
        service_name = service
        plan_name    = split("=", plan)[0]
        amount       = length(split("=", plan)) > 1 ? split("=", plan)[1] : "0"
      }
    ]
  ])
}

resource "btp_subaccount_entitlement" "entitlement" {
  for_each = {
    for entitlement in local.parsed_entitlements_data :
    "${entitlement.service_name}-${entitlement.plan_name}" => entitlement
  }
  subaccount_id = var.subaccount
  service_name  = each.value.service_name
  plan_name     = each.value.plan_name
  amount        = each.value.amount != "0" ? each.value.amount : null
}
