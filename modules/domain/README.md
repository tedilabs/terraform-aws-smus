# domain

This module creates following resources.

- `aws_datazone_domain`
- `aws_iam_role` (optional)
- `aws_iam_role_policy` (optional)
- `aws_iam_role_policy_attachment` (optional)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.33 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.62.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_execution_role"></a> [execution\_role](#module\_execution\_role) | tedilabs/account/aws//modules/iam-role | ~> 0.33.11 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.12.0 |
| <a name="module_service_role"></a> [service\_role](#module\_service\_role) | tedilabs/account/aws//modules/iam-role | ~> 0.33.11 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_datazone_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datazone_domain) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the SageMaker Unified Studio domain. | `string` | n/a | yes |
| <a name="input_default_execution_role"></a> [default\_execution\_role](#input\_default\_execution\_role) | (Optional) A configuration for the default domain execution role which is assumed by SageMaker Unified Studio to call APIs on behalf of the authorized users of the domain. Use `execution_role` if `default_execution_role.enabled` is `false`. `default_execution_role` as defined below.<br/>    (Optional) `enabled` - Whether to create the default domain execution role. Defaults to `true`.<br/>    (Optional) `name` - The name of the default domain execution role. Defaults to `smus-domain-${var.name}-execution`.<br/>    (Optional) `path` - The path of the default domain execution role. Defaults to `/`.<br/>    (Optional) `description` - The description of the default domain execution role.<br/>    (Optional) `policies` - A list of IAM policy ARNs to attach to the default domain execution role. `SageMakerStudioDomainExecutionRolePolicy` is always attached. Defaults to `[]`.<br/>    (Optional) `inline_policies` - A map of inline IAM policies to attach to the default domain execution role. (`name` => `policy`).<br/>    (Optional) `permissions_boundary` - The ARN of the IAM policy to use as permissions boundary for the default domain execution role. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string)<br/>    path        = optional(string, "/")<br/>    description = optional(string, "Managed by Terraform.")<br/><br/>    policies             = optional(list(string), [])<br/>    inline_policies      = optional(map(string), {})<br/>    permissions_boundary = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_default_service_role"></a> [default\_service\_role](#input\_default\_service\_role) | (Optional) A configuration for the default service role which is used by SageMaker Unified Studio for the domain level actions. Use `service_role` if `default_service_role.enabled` is `false`. `default_service_role` as defined below.<br/>    (Optional) `enabled` - Whether to create the default service role. Defaults to `true`.<br/>    (Optional) `name` - The name of the default service role. Defaults to `smus-domain-${var.name}-service`.<br/>    (Optional) `path` - The path of the default service role. Defaults to `/`.<br/>    (Optional) `description` - The description of the default service role.<br/>    (Optional) `policies` - A list of IAM policy ARNs to attach to the default service role. `SageMakerStudioDomainServiceRolePolicy` is always attached. Defaults to `[]`.<br/>    (Optional) `inline_policies` - A map of inline IAM policies to attach to the default service role. (`name` => `policy`).<br/>    (Optional) `permissions_boundary` - The ARN of the IAM policy to use as permissions boundary for the default service role. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string)<br/>    path        = optional(string, "/")<br/>    description = optional(string, "Managed by Terraform.")<br/><br/>    policies             = optional(list(string), [])<br/>    inline_policies      = optional(map(string), {})<br/>    permissions_boundary = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the SageMaker Unified Studio domain. Defaults to `Managed by Terraform.`. | `string` | `"Managed by Terraform."` | no |
| <a name="input_encryption"></a> [encryption](#input\_encryption) | (Optional) A configuration to encrypt the domain, metadata and reporting data at rest. The data at rest is always encrypted with an AWS owned key by default, and this layer of encryption cannot be disabled. `encryption` as defined below.<br/>    (Optional) `kms_key` - The ARN of the AWS KMS key which is used to encrypt the domain, metadata and reporting data. Only a symmetric customer managed key is supported. If not provided, an AWS owned key is used for the encryption. | <pre>object({<br/>    kms_key = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_execution_role"></a> [execution\_role](#input\_execution\_role) | (Optional) The ARN (Amazon Resource Name) of the IAM role which is assumed by SageMaker Unified Studio to call APIs on behalf of the authorized users of the domain. Only required if `default_execution_role.enabled` is `false`. | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | (Optional) Whether to delete all child entities (like projects and environments) within the domain when destroying the domain. Without `force_destroy`, a domain which still contains any child entities will fail to be destroyed. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.<br/>    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.<br/>    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.<br/>    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string, "")<br/>    description = optional(string, "Managed by Terraform.")<br/>  })</pre> | `{}` | no |
| <a name="input_service_role"></a> [service\_role](#input\_service\_role) | (Optional) The ARN (Amazon Resource Name) of the IAM role which is used by SageMaker Unified Studio for the domain level actions. Only required if `default_service_role.enabled` is `false`. | `string` | `null` | no |
| <a name="input_single_sign_on"></a> [single\_sign\_on](#input\_single\_sign\_on) | (Optional) A configuration of the authentication method for the users of the domain. `single_sign_on` as defined below.<br/>    (Optional) `type` - The authentication method of the domain. Valid values are `IAM_IDC` and `DISABLED`. Defaults to `DISABLED`.<br/>      `IAM_IDC` - Authenticate the users with the AWS IAM Identity Center instance of the account. The IAM Identity Center instance should be enabled before creating the domain.<br/>      `DISABLED` - Authenticate the users with federated IAM roles. (a.k.a. IAM-based domain)<br/>    (Optional) `user_assignment` - The strategy to assign the users of the IAM Identity Center instance to the domain. Valid values are `AUTOMATIC` and `MANUAL`. Only used if `single_sign_on.type` is `IAM_IDC`.<br/>      `AUTOMATIC` - Every user of the IAM Identity Center instance is able to access the domain.<br/>      `MANUAL` - Only the users who are explicitly added to the domain are able to access the domain. | <pre>object({<br/>    type            = optional(string, "DISABLED")<br/>    user_assignment = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) How long to wait for the SageMaker Unified Studio domain to be created/deleted. | <pre>object({<br/>    create = optional(string, "10m")<br/>    delete = optional(string, "10m")<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the SageMaker Unified Studio domain. |
| <a name="output_description"></a> [description](#output\_description) | The description of the SageMaker Unified Studio domain. |
| <a name="output_domain_version"></a> [domain\_version](#output\_domain\_version) | The version of the domain. Always `V2` which is the domain version of SageMaker Unified Studio. |
| <a name="output_encryption"></a> [encryption](#output\_encryption) | The configuration to encrypt the domain, metadata and reporting data at rest. |
| <a name="output_execution_role"></a> [execution\_role](#output\_execution\_role) | The Amazon Resource Name (ARN) of the IAM role which is assumed by SageMaker Unified Studio to call APIs on behalf of the authorized users of the domain. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the SageMaker Unified Studio domain. |
| <a name="output_name"></a> [name](#output\_name) | The name of the SageMaker Unified Studio domain. |
| <a name="output_portal_url"></a> [portal\_url](#output\_portal\_url) | The URL of the data portal of the SageMaker Unified Studio domain. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this module resources resides in. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | The resource group created to manage resources in this module. |
| <a name="output_root_domain_unit_id"></a> [root\_domain\_unit\_id](#output\_root\_domain\_unit\_id) | The ID of the root domain unit of the SageMaker Unified Studio domain. |
| <a name="output_service_role"></a> [service\_role](#output\_service\_role) | The Amazon Resource Name (ARN) of the IAM role which is used by SageMaker Unified Studio for the domain level actions. |
| <a name="output_single_sign_on"></a> [single\_sign\_on](#output\_single\_sign\_on) | The configuration of the authentication method for the users of the domain. |
<!-- END_TF_DOCS -->