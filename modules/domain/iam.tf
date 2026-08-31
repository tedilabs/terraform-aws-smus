data "aws_caller_identity" "this" {}

locals {
  account_id = data.aws_caller_identity.this.account_id

  execution_role = (var.default_execution_role.enabled
    ? module.execution_role[0].arn
    : var.execution_role
  )
  service_role = (var.default_service_role.enabled
    ? module.service_role[0].arn
    : var.service_role
  )
}


###################################################
# IAM Role for Domain Execution
###################################################

# INFO: Equivalent to the `AmazonSageMakerDomainExecution` role which is created by
# the SageMaker Unified Studio console.
module "execution_role" {
  count = var.default_execution_role.enabled ? 1 : 0

  source  = "tedilabs/account/aws//modules/iam-role"
  version = "~> 0.33.11"

  name = coalesce(
    var.default_execution_role.name,
    "smus-domain-${local.metadata.name}-execution",
  )
  path        = var.default_execution_role.path
  description = var.default_execution_role.description

  trusted_service_policies = [
    {
      services = ["datazone.amazonaws.com"]
      conditions = [
        {
          key       = "aws:SourceAccount"
          condition = "StringEquals"
          values    = [local.account_id]
        },
      ]
    },
  ]

  # INFO: The domain execution role is assumed on behalf of the users of the domain.
  # So it requires `sts:TagSession` for the `datazone*` session tags, and
  # `sts:SetContext` for the trusted identity propagation.
  trusted_session_tagging = {
    enabled = true
  }
  trusted_session_context = {
    enabled = true
  }
  trusted_source_identity = {
    enabled = false
  }

  policies = concat(
    ["arn:aws:iam::aws:policy/service-role/SageMakerStudioDomainExecutionRolePolicy"],
    var.default_execution_role.policies,
  )
  inline_policies = var.default_execution_role.inline_policies

  permissions_boundary = var.default_execution_role.permissions_boundary

  force_detach_policies = true
  resource_group = {
    enabled = false
  }
  module_tags_enabled = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}


###################################################
# IAM Role for Domain Service
###################################################

# INFO: Equivalent to the `AmazonSageMakerDomainService` role which is created by
# the SageMaker Unified Studio console.
module "service_role" {
  count = var.default_service_role.enabled ? 1 : 0

  source  = "tedilabs/account/aws//modules/iam-role"
  version = "~> 0.33.11"

  name = coalesce(
    var.default_service_role.name,
    "smus-domain-${local.metadata.name}-service",
  )
  path        = var.default_service_role.path
  description = var.default_service_role.description

  trusted_service_policies = [
    {
      services = ["datazone.amazonaws.com"]
      conditions = [
        {
          key       = "aws:SourceAccount"
          condition = "StringEquals"
          values    = [local.account_id]
        },
      ]
    },
  ]
  trusted_session_tagging = {
    enabled = false
  }
  trusted_session_context = {
    enabled = false
  }
  trusted_source_identity = {
    enabled = false
  }

  policies = concat(
    ["arn:aws:iam::aws:policy/service-role/SageMakerStudioDomainServiceRolePolicy"],
    var.default_service_role.policies,
  )
  inline_policies = var.default_service_role.inline_policies

  permissions_boundary = var.default_service_role.permissions_boundary

  force_detach_policies = true
  resource_group = {
    enabled = false
  }
  module_tags_enabled = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}
