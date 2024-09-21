terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Replace with your desired region
  access_key = "AKIARZ5BMOH2OEFKLQM2"
  secret_key = "W3D7qBWv+o5JTj+ZdsvKjEJETC7j/Vssre8LbtNi"
}