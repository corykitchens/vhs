# Variables
# - key_name
# - instance_size
# - ami_id
variable "key_name" {
  type    = "string"
  default = "HelloWorld"
}

variable "instance_size" {
  type    = "string"
  default = "t3.medium"
}

variable "ami_id" {
  type    = "string"
  default = "ami-0a1d405ce719bebfd"
}
