output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_datazone_domain.this.region
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the SageMaker Unified Studio domain."
  value       = aws_datazone_domain.this.arn
}

output "id" {
  description = "The ID of the SageMaker Unified Studio domain."
  value       = aws_datazone_domain.this.id
}

output "name" {
  description = "The name of the SageMaker Unified Studio domain."
  value       = aws_datazone_domain.this.name
}

output "description" {
  description = "The description of the SageMaker Unified Studio domain."
  value       = aws_datazone_domain.this.description
}

output "domain_version" {
  description = "The version of the domain. Always `V2` which is the domain version of SageMaker Unified Studio."
  value       = aws_datazone_domain.this.domain_version
}

output "portal_url" {
  description = "The URL of the data portal of the SageMaker Unified Studio domain."
  value       = aws_datazone_domain.this.portal_url
}

output "root_domain_unit_id" {
  description = "The ID of the root domain unit of the SageMaker Unified Studio domain."
  value       = aws_datazone_domain.this.root_domain_unit_id
}

output "single_sign_on" {
  description = "The configuration of the authentication method for the users of the domain."
  value = {
    type            = one(aws_datazone_domain.this.single_sign_on[*].type)
    user_assignment = one(aws_datazone_domain.this.single_sign_on[*].user_assignment)
  }
}

output "execution_role" {
  description = "The Amazon Resource Name (ARN) of the IAM role which is assumed by SageMaker Unified Studio to call APIs on behalf of the authorized users of the domain."
  value       = aws_datazone_domain.this.domain_execution_role
}

output "service_role" {
  description = "The Amazon Resource Name (ARN) of the IAM role which is used by SageMaker Unified Studio for the domain level actions."
  value       = aws_datazone_domain.this.service_role
}

output "encryption" {
  description = "The configuration to encrypt the domain, metadata and reporting data at rest."
  value = {
    kms_key = aws_datazone_domain.this.kms_key_identifier
  }
}

output "resource_group" {
  description = "The resource group created to manage resources in this module."
  value = merge(
    {
      enabled = var.resource_group.enabled && var.module_tags_enabled
    },
    (var.resource_group.enabled && var.module_tags_enabled
      ? {
        arn  = module.resource_group[0].arn
        name = module.resource_group[0].name
      }
      : {}
    )
  )
}
