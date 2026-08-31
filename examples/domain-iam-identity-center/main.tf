provider "aws" {
  region = "ap-northeast-2"
}


###################################################
# SMUS Domain with IAM Identity Center Authentication
###################################################

# INFO: An AWS IAM Identity Center instance should be enabled in the same region before
# creating the domain. The domain is associated with the IAM Identity Center instance
# of the account.
# INFO: The domain execution role and the service role which SageMaker Unified Studio
# requires are created by the module with the default configurations.
module "domain" {
  source = "../../modules/domain"
  # source  = "tedilabs/smus/aws//modules/domain"
  # version = "~> 0.1.0"

  name        = "iam-identity-center"
  description = "This domain is created with IAM Identity Center authentication."

  single_sign_on = {
    type = "IAM_IDC"

    # INFO: Every user of the IAM Identity Center instance is able to access the domain.
    # Use `MANUAL` to allow only the users who are explicitly added to the domain.
    user_assignment = "AUTOMATIC"
  }

  force_destroy = true

  tags = {
    "project" = "terraform-aws-smus-examples"
  }
}
