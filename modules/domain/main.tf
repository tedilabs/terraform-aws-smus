locals {
  metadata = {
    package = "terraform-aws-smus"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
  module_tags = var.module_tags_enabled ? {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  } : {}
}


###################################################
# Domain of SageMaker Unified Studio
###################################################

# INFO: SageMaker Unified Studio is built on top of the `V2` domain of Amazon DataZone.
resource "aws_datazone_domain" "this" {
  region = var.region

  name        = var.name
  description = var.description

  domain_version = "V2"


  ## Authentication
  single_sign_on {
    type = var.single_sign_on.type
    user_assignment = (var.single_sign_on.type == "IAM_IDC"
      ? var.single_sign_on.user_assignment
      : null
    )
  }


  ## Permissions
  domain_execution_role = local.execution_role
  service_role          = local.service_role


  ## Encryption
  kms_key_identifier = var.encryption.kms_key


  ## Lifecycle
  skip_deletion_check = var.force_destroy

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}
