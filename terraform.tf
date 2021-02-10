provider "aws" {
	region = "us-east-1"
}

resource "aws_cognito_user_pool" "mypool" {
  name = "mypool"
  auto_verified_attributes = ["email"]

	schema {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = false
        name                     = "email"
        required                 = true

        string_attribute_constraints {
            max_length = "2048"
            min_length = "0"
        }
    }
}

resource "aws_cognito_user_pool_client" "myclient" {
  name = "myclient"
  user_pool_id = aws_cognito_user_pool.mypool.id
  allowed_oauth_flows = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes = ["email", "openid"]
  supported_identity_providers = ["COGNITO"]
  callback_urls = ["https://54.86.237.101:5000/aws_cognito_redirect"]
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "bbb-random-example-domain"
  user_pool_id = aws_cognito_user_pool.mypool.id
}

resource "aws_ecr_repository" "myecr" {
  name                 = "myecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_codebuild_project" "mycodebuildproject" {
    name           = "mycodebuildproject"
    badge_enabled  = false
    build_timeout  = 60
    queued_timeout = 480
    service_role   = "arn:aws:iam::159560289908:role/service-role/billyboyballin_codebuild_role"
    tags           = {}

    artifacts {
        encryption_disabled    = false
        override_artifact_name = false
        type                   = "NO_ARTIFACTS"
    }

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
        image_pull_credentials_type = "CODEBUILD"
        privileged_mode             = true
        type                        = "LINUX_CONTAINER"
    }

    logs_config {
        cloudwatch_logs {
            status = "ENABLED"
        }

        s3_logs {
            encryption_disabled = false
            status              = "DISABLED"
        }
    }

    source {
		type            = "GITHUB"
    	location        = "https://github.com/billyboyballin/flaskcognito"
    	git_clone_depth = 1
    }
}
