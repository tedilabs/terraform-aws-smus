variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) The name of the SageMaker Unified Studio domain."
  type        = string
  nullable    = false
}

variable "description" {
  description = "(Optional) The description of the SageMaker Unified Studio domain. Defaults to `Managed by Terraform.`."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}

variable "single_sign_on" {
  description = <<EOF
  (Optional) A configuration of the authentication method for the users of the domain. `single_sign_on` as defined below.
    (Optional) `type` - The authentication method of the domain. Valid values are `IAM_IDC` and `DISABLED`. Defaults to `DISABLED`.
      `IAM_IDC` - Authenticate the users with the AWS IAM Identity Center instance of the account. The IAM Identity Center instance should be enabled before creating the domain.
      `DISABLED` - Authenticate the users with federated IAM roles. (a.k.a. IAM-based domain)
    (Optional) `user_assignment` - The strategy to assign the users of the IAM Identity Center instance to the domain. Valid values are `AUTOMATIC` and `MANUAL`. Defaults to `AUTOMATIC`. Only used if `single_sign_on.type` is `IAM_IDC`.
      `AUTOMATIC` - Every user of the IAM Identity Center instance is able to access the domain.
      `MANUAL` - Only the users who are explicitly added to the domain are able to access the domain.
  EOF
  type = object({
    type            = optional(string, "DISABLED")
    user_assignment = optional(string, "AUTOMATIC")
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["IAM_IDC", "DISABLED"], var.single_sign_on.type)
    error_message = "Valid values for `single_sign_on.type` are `IAM_IDC` and `DISABLED`."
  }
  validation {
    condition = anytrue([
      var.single_sign_on.user_assignment == null,
      contains(["AUTOMATIC", "MANUAL"], coalesce(var.single_sign_on.user_assignment, "AUTOMATIC")),
    ])
    error_message = "Valid values for `single_sign_on.user_assignment` are `AUTOMATIC` and `MANUAL`."
  }
}

variable "default_execution_role" {
  description = <<EOF
  (Optional) A configuration for the default domain execution role which is assumed by SageMaker Unified Studio to call APIs on behalf of the authorized users of the domain. Use `execution_role` if `default_execution_role.enabled` is `false`. `default_execution_role` as defined below.
    (Optional) `enabled` - Whether to create the default domain execution role. Defaults to `true`.
    (Optional) `name` - The name of the default domain execution role. Defaults to `smus-domain-$${var.name}-execution`.
    (Optional) `path` - The path of the default domain execution role. Defaults to `/`.
    (Optional) `description` - The description of the default domain execution role.
    (Optional) `policies` - A list of IAM policy ARNs to attach to the default domain execution role. `SageMakerStudioDomainExecutionRolePolicy` is always attached. Defaults to `[]`.
    (Optional) `inline_policies` - A map of inline IAM policies to attach to the default domain execution role. (`name` => `policy`).
    (Optional) `permissions_boundary` - The ARN of the IAM policy to use as permissions boundary for the default domain execution role.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string)
    path        = optional(string, "/")
    description = optional(string, "Managed by Terraform.")

    policies             = optional(list(string), [])
    inline_policies      = optional(map(string), {})
    permissions_boundary = optional(string)
  })
  default  = {}
  nullable = false
}

variable "execution_role" {
  description = "(Optional) The ARN (Amazon Resource Name) of the IAM role which is assumed by SageMaker Unified Studio to call APIs on behalf of the authorized users of the domain. Only required if `default_execution_role.enabled` is `false`."
  type        = string
  default     = null
  nullable    = true
}

variable "default_service_role" {
  description = <<EOF
  (Optional) A configuration for the default service role which is used by SageMaker Unified Studio for the domain level actions. Use `service_role` if `default_service_role.enabled` is `false`. `default_service_role` as defined below.
    (Optional) `enabled` - Whether to create the default service role. Defaults to `true`.
    (Optional) `name` - The name of the default service role. Defaults to `smus-domain-$${var.name}-service`.
    (Optional) `path` - The path of the default service role. Defaults to `/`.
    (Optional) `description` - The description of the default service role.
    (Optional) `policies` - A list of IAM policy ARNs to attach to the default service role. `SageMakerStudioDomainServiceRolePolicy` is always attached. Defaults to `[]`.
    (Optional) `inline_policies` - A map of inline IAM policies to attach to the default service role. (`name` => `policy`).
    (Optional) `permissions_boundary` - The ARN of the IAM policy to use as permissions boundary for the default service role.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string)
    path        = optional(string, "/")
    description = optional(string, "Managed by Terraform.")

    policies             = optional(list(string), [])
    inline_policies      = optional(map(string), {})
    permissions_boundary = optional(string)
  })
  default  = {}
  nullable = false
}

variable "service_role" {
  description = "(Optional) The ARN (Amazon Resource Name) of the IAM role which is used by SageMaker Unified Studio for the domain level actions. Only required if `default_service_role.enabled` is `false`."
  type        = string
  default     = null
  nullable    = true
}

variable "encryption" {
  description = <<EOF
  (Optional) A configuration to encrypt the domain, metadata and reporting data at rest. The data at rest is always encrypted with an AWS owned key by default, and this layer of encryption cannot be disabled. `encryption` as defined below.
    (Optional) `kms_key` - The ARN of the AWS KMS key which is used to encrypt the domain, metadata and reporting data. Only a symmetric customer managed key is supported. If not provided, an AWS owned key is used for the encryption.
  EOF
  type = object({
    kms_key = optional(string)
  })
  default  = {}
  nullable = false
}

variable "force_destroy" {
  description = "(Optional) Whether to delete all child entities (like projects and environments) within the domain when destroying the domain. Without `force_destroy`, a domain which still contains any child entities will fail to be destroyed. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "timeouts" {
  description = "(Optional) How long to wait for the SageMaker Unified Studio domain to be created/deleted."
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default  = {}
  nullable = false
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
  nullable    = false
}


###################################################
# Resource Group
###################################################

variable "resource_group" {
  description = <<EOF
  (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.
    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.
    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.
    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string, "")
    description = optional(string, "Managed by Terraform.")
  })
  default  = {}
  nullable = false
}
