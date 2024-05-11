#Configure AWS provider

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  #Since I have my AWS secret access key and secrest access key ID as environment 
  #variables, terraform will use it as default
  profile = "default"
  region = "us-east-1"
}

