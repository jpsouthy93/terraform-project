terraform {
  required_version = ">= 1.0.0"
  backend "s3" {
    bucket         = "<YOUR-REMOTE-BUCKET-NAME"
    key            = "ce-terraform-remote-state/s3/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "<YOUR-DYNAMODB-TABLE-NAME"
    encrypt        = true
  }
}