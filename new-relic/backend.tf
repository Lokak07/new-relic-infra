# enabled versioning and state locking on s3

terraform {
  required_version = ">= 1.5.0"
  backend "s3" {
    bucket         = "my-secure-terraform-state-shakthi-v2"
    key            = "vpc/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
    # No dynamodb table — trying to use native locking.
  }
}

