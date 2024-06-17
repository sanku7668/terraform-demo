/* this is our first terrafom script
   Author: Sanket
   USer story : Ind-12345 */

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
