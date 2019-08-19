# Variables
# - key_name
# - instance_size
# - ami_id
variable "key_name" {
  type = "string"
  default = "HelloWorld"
}

variable "instance_size" {
  type    = "string"
  default = "t2.micro"
}

variable "ami_id" {
  type    = "string"
  default = "ami-057549bd0bba43bc1"
}
