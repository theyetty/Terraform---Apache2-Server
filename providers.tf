provider "aws" {
  profile = var.profile
  region  = var.region
  alias   = "provider"
}