// Use the default profile
variable "profile" {
  type    = string
  default = "default"
}

// The Region
variable "region" {
  type    = string
  default = "us-east-1"
}

// Instance to be launched
variable "instance-type" {
  type    = string
  default = "t3.micro"
}
