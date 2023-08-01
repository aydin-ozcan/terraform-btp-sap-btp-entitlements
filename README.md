
# SAP BTP Entitlements Management with Terraform Module: sap-btp-entitlements

Terraform , where you can manage your infrastructure and keep your sanity at the same time. Often referred to as Infrastructure as Code (IoC), it allows you to provision and manage resources using code. I like to think of it as a stateful API manager and HTTP client that goes beyond cloud provisioning and can handle anything that exposes an API in a stateful manner.

In this blog post, I will introduce you to a Terraform module that I developed to simplify the management of entitlements: "sap-btp-entitlements". This module will reduce your code from a novel to a short story.

## Terraform Modules: Your Blueprint for Infrastructure

Terraform modules are self-contained packages of Terraform configurations that act as building blocks for your infrastructure. They provide a way to encapsulate complexity and promote reusability across different projects. By creating a dedicated module for managing entitlements, we can simplify the overall Terraform codebase and improve its maintainability.

## The Traditional Approach to Entitlement Creation

Let's take a look at how traditional resource creation for entitlements would look like with the [SAP BTP Terraform provider](https://registry.terraform.io/providers/SAP/btp/):

```hcl
resource "btp_subaccount_entitlement" "application_logs" {
 subaccount_id = btp_subaccount.acme.id
 service_name  = "application-logs"
 plan_name     = "lite"
}

resource "btp_subaccount_entitlement" "xsuaa" {
 subaccount_id = btp_subaccount.acme.id
 service_name  = "xsuaa"
 plan_name     = "application"
}

resource "btp_subaccount_entitlement" "xsuaa_broker" {
 subaccount_id = btp_subaccount.acme.id
 service_name  = "xsuaa"
 plan_name     = "broker"
}

# And so on, repeating this for every entitlement needed.
```

As you can see, for each service and each plan offered by the service, you need to create separate resources. This can lead to a considerable amount of repetitive code and increased chances of errors.

## SAP BTP Entitlements Module

To address the challenges I have developed a Terraform module specifically for managing entitlements in SAP BTP. sap-btp-entitlements module provides elegant and efficient way to describe your entitlements. Let's take a look at how it works:

```hcl
module "sap-btp-entitlements" {
 source = "aydin-ozcan/sap-btp-entitlements"
 entitlements = {
   "alert-notification"     = ["standard"],
   "application-logs"       = ["lite"],
   "xsuaa"                  = ["application", "broker"],
   "kymaruntime"            = ["trial=1"],  
   "APPLICATION_RUNTIME"    = ["MEMORY=1"]  # Cloud Foundry and Kyma needs to specify amount even if it is 1
 }
}
```

With this module, you can specify your entitlements in a simple format, significantly reducing the amount of code you need to write. The module even allows you to set the amount for the entitlements; otherwise, it defaults to the service offerings' defaults.

## How to Access and Use the Module

You can easily access and initialize the [sap-btp-entitlements](https://registry.terraform.io/modules/aydin-ozcan/sap-btp-entitlements) module from the Terraform registry. 

The module's source code and additional usage examples can be found on GitHub at the following repository:

[GitHub Repository - SAP BTP Entitlements](https://github.com/aydin-ozcan/terraform-btp-sap-btp-entitlements)


[SAP BTP Terraform provider](https://registry.terraform.io/providers/SAP/btp/) offers a robust solution for professional infrastructure management.
By utilizing [sap-btp-entitlements](https://registry.terraform.io/modules/aydin-ozcan/sap-btp-entitlements) you will :

- Simplify the codebase.
- Reduce the risk of errors.
- Improve maintainability.
