provider "aws" {
  region = "us-east-1"
}


###################################################
# SMUS Domain with IAM-based Authentication
###################################################

# INFO: In an IAM-based domain, the users sign in to SageMaker Unified Studio with
# federated IAM roles instead of the AWS IAM Identity Center.
# INFO: The domain execution role and the service role which SageMaker Unified Studio
# requires are created by the module with the default configurations.
module "domain" {
  source = "../../modules/domain"
  # source  = "tedilabs/smus/aws//modules/domain"
  # version = "~> 0.1.0"

  name        = "iam-based"
  description = "This domain is created with IAM-based authentication."

  single_sign_on = {
    type = "DISABLED"
  }

  force_destroy = true

  tags = {
    "project" = "terraform-aws-smus-examples"
  }
}
