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
  callback_urls = ["http://localhost:5000/aws_cognito_redirect"]
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "my-random-example-domain"
  user_pool_id = aws_cognito_user_pool.mypool.id
}

resource "aws_ecr_repository" "myecr" {
  name                 = "myecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
