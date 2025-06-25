<!-- Update the title -->
# IBM MQ Operator on Red Hat OpenShift Container Platform module

<!--
Update status and "latest release" badges:
  1. For the status options, see https://terraform-ibm-modules.github.io/documentation/#/badge-status
  2. Update the "latest release" badge to point to the correct module's repo. Replace "terraform-ibm-module-template" in two places.
-->
[![Implemented (No quality checks)](https://img.shields.io/badge/Status-Implemented%20(No%20quality%20checks)-yellowgreen)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-module-template?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-module-template/releases/latest)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

<!-- Add a description of module(s) in this repo -->
The module installs an IBM MQ operator on the existing cluster.

For more information about the IBM MQ operator refer to the official documentation available [here](https://www.ibm.com/docs/en/ibm-mq/9.3?topic=integration-using-mq-operator)

For more information about the IBM MQ refer to the official documentation available [here](https://www.ibm.com/docs/en/ibm-mq/9.3?topic=mq-about)


<!-- Below content is automatically populated via pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-mq-operator](#terraform-ibm-mq-operator)
* [Examples](./examples)
    * [Complete example](./examples/complete)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->


<!--
If this repo contains any reference architectures, uncomment the heading below and links to them.
(Usually in the `/reference-architectures` directory.)
See "Reference architecture" in Authoring Guidelines in the public documentation at
https://terraform-ibm-modules.github.io/documentation/#/implementation-guidelines?id=reference-architecture
-->
<!-- ## Reference architectures -->


<!-- This heading should always match the name of the root level module (aka the repo name) -->
## terraform-ibm-mq-operator

### Usage

<!--
Add an example of the use of the module in the following code block.

Use real values instead of "var.<var_name>" or other placeholder values
unless real values don't help users know what to change.
-->

```hcl

##############################################################################
# Config providers
##############################################################################

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key # pragma: allowlist secret
  region           = var.region
}

provider "helm" {
  kubernetes {
    host  = data.ibm_container_cluster_config.cluster_config.host
    token = data.ibm_container_cluster_config.cluster_config.token
  }
}

provider "kubernetes" {
  host  = data.ibm_container_cluster_config.cluster_config.host
  token = data.ibm_container_cluster_config.cluster_config.token
}

##############################################################################
# IBM MQ operator deployment on the OCP cluster
##############################################################################

data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id = var.cluster_id
  config_dir      = "${path.module}/kubeconfig"
  endpoint_type   = var.cluster_config_endpoint_type != "default" ? var.cluster_config_endpoint_type : null # null represents default
}

module "ibm_mq_operator" {
  # Replace "master" with a GIT release version to lock into a specific release
  source                                = "https://github.com/terraform-ibm-modules/terraform-ibm-mq-operator.git?ref=master"
  cluster_id                            = var.cluster_id
  add_ibm_operator_catalog              = true
  create_ibm_mq_operator_namespace      = false
  ibm_mq_operator_namespace             = "openshift-operators"
  ibm_mq_operator_target_namespace      = "ibm-mq-operator"
  cluster_config_endpoint_type          = "default"
  operator_helm_release_namespace       = "ibm-mq-operator"
  create_ibm_mq_queue_manager_namespace = true
  ibm_mq_queue_manager_namespace        = "ibm-mq-operator-qm"
  create_queue_manager                  = var.create_queue_manager
  queue_manager_name                    = "ibm-mq-operator-qm"
  queue_manager_license                 = var.queue_manager_license
  queue_manager_license_usage           = var.queue_manager_license_usage
  queue_manager_version                 = var.queue_manager_version
}

locals {
  mq_queue_manager_web_url = var.create_queue_manager ? "https://${module.ibm_mq_operator.ibm_mq_queue_manager_web_url}/ibmmq/console/login.html" : "MQ Queue Manager is not deployed."
}

output "ibm_mq_queue_manager_web_url" {
  description = "Queue Manager web URL"
  value       = local.mq_queue_manager_web_url
}
```

### Required IAM access policies

<!-- PERMISSIONS REQUIRED TO RUN MODULE
If this module requires permissions, uncomment the following block and update
the sample permissions, following the format.
Replace the sample Account and IBM Cloud service names and roles with the
information in the console at
Manage > Access (IAM) > Access groups > Access policies.
-->

- IAM Services
  - **Kubernetes** service
      - `Viewer` platform access
      - `Manager` service access

<!-- NO PERMISSIONS FOR MODULE
If no permissions are required for the module, uncomment the following
statement instead the previous block.
-->

<!-- No permissions are needed to run this module.-->


<!-- Below content is automatically populated via pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_external"></a> [external](#requirement\_external) | >=2.2.3, <3.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.8.0, <3.0.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.59.0, < 2.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.16.1, <3.0.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.1, < 4.0.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9.1, < 1.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [helm_release.ibm_mq_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ibm_mq_operator_group](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ibm_mq_queue_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ibm_operator_catalog](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.helm_release_operator_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.ibm_mq_operator_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.ibm_mq_queue_manager_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [null_resource.confirm_ibm_mq_operator_operational](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [time_sleep.wait_catalog](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_ibm_mq_operator](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_ibm_mq_queue_manager](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [external_external.mq_queue_manager_url](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [ibm_container_cluster_config.cluster_config](https://registry.terraform.io/providers/ibm-cloud/ibm/latest/docs/data-sources/container_cluster_config) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_ibm_operator_catalog"></a> [add\_ibm\_operator\_catalog](#input\_add\_ibm\_operator\_catalog) | Install the IBM Operator Catalog in the cluster before installing the IBM MQ Operator. Default is `true`. | `bool` | `true` | no |
| <a name="input_cluster_config_endpoint_type"></a> [cluster\_config\_endpoint\_type](#input\_cluster\_config\_endpoint\_type) | Specify which type of endpoint to use for for cluster config access: 'default', 'private', 'vpe', 'link'. 'default' value will use the default endpoint of the cluster. | `string` | `"default"` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | ID of the target cluster where the IBM MQ operator will be installed. | `string` | n/a | yes |
| <a name="input_create_ibm_mq_operator_namespace"></a> [create\_ibm\_mq\_operator\_namespace](#input\_create\_ibm\_mq\_operator\_namespace) | Set to true to create the namespace where the IBM MQ Operator will be deployed. Default to `false`. | `bool` | `false` | no |
| <a name="input_create_ibm_mq_queue_manager_namespace"></a> [create\_ibm\_mq\_queue\_manager\_namespace](#input\_create\_ibm\_mq\_queue\_manager\_namespace) | Set to true to create the namespace where the IBM MQ Queue Manager will be installed. Default to `true`. | `bool` | `true` | no |
| <a name="input_create_queue_manager"></a> [create\_queue\_manager](#input\_create\_queue\_manager) | Set to true to create a Queue Manager for the IBM MQ operator. Default is `true`. | `bool` | `true` | no |
| <a name="input_ibm_mq_operator_namespace"></a> [ibm\_mq\_operator\_namespace](#input\_ibm\_mq\_operator\_namespace) | Namespace where the IBM MQ operator is deployed. Default is `openshift-operators`. | `string` | `"openshift-operators"` | no |
| <a name="input_ibm_mq_operator_target_namespace"></a> [ibm\_mq\_operator\_target\_namespace](#input\_ibm\_mq\_operator\_target\_namespace) | Namespace to be watched by the IBM MQ Operator. Default is `null`, which means that the operator watches all the namespaces. | `string` | `null` | no |
| <a name="input_ibm_mq_queue_manager_namespace"></a> [ibm\_mq\_queue\_manager\_namespace](#input\_ibm\_mq\_queue\_manager\_namespace) | Namespace where the IBM MQ Queue Manager will be installed. Its only used when `var.create_ibm_mq_queue_manager_namespace` is set to true. | `string` | `null` | no |
| <a name="input_operator_helm_release_namespace"></a> [operator\_helm\_release\_namespace](#input\_operator\_helm\_release\_namespace) | Namespace where the helm releases are deployed. Default is `ibm-mq-operator`. | `string` | `"ibm-mq-operator"` | no |
| <a name="input_queue_manager_license"></a> [queue\_manager\_license](#input\_queue\_manager\_license) | IBM MQ Queue Manager license. More info on IBM MQ Queue Manager licenses and its usage can be seen here: https://www.ibm.com/docs/en/ibm-mq/9.3?topic=mqibmcomv1beta1-licensing-reference. | `string` | `null` | no |
| <a name="input_queue_manager_license_usage"></a> [queue\_manager\_license\_usage](#input\_queue\_manager\_license\_usage) | IBM MQ Queue Manager license usage. More info on IBM MQ Queue Manager licenses and its usage can be seen here: https://www.ibm.com/docs/en/ibm-mq/9.3?topic=mqibmcomv1beta1-licensing-reference. | `string` | `null` | no |
| <a name="input_queue_manager_name"></a> [queue\_manager\_name](#input\_queue\_manager\_name) | Name of the IBM MQ Queue Manager. | `string` | `null` | no |
| <a name="input_queue_manager_version"></a> [queue\_manager\_version](#input\_queue\_manager\_version) | IBM MQ Queue Manager version. Make sure the version is compatible with the IBM MQ Queue Manager license and usage. | `string` | `"9.3.3.3-r1"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_ibm_mq_operator_namespace"></a> [ibm\_mq\_operator\_namespace](#output\_ibm\_mq\_operator\_namespace) | Namespace where the IBM MQ operator is installed. |
| <a name="output_ibm_mq_operator_target_namespace"></a> [ibm\_mq\_operator\_target\_namespace](#output\_ibm\_mq\_operator\_target\_namespace) | Namespace watched by the IBM MQ operator. |
| <a name="output_ibm_mq_queue_manager_web_url"></a> [ibm\_mq\_queue\_manager\_web\_url](#output\_ibm\_mq\_queue\_manager\_web\_url) | Queue Manager web URL |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
