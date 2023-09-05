terraform {
  required_version = ">= 1.0.0"
  backend "s3" {
    bucket         = "<BUCKET-NAME>"
    key            = "<BUCKET-NAME>/s3/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "<DYNAMO-TABLE-NAME>"
    encrypt        = true
  }
}