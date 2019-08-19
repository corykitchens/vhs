# # Main
# # vars
# # - instance_size
# # - ami_id

# # resources
# # - EC2 Server /w Windows 2016
# # - PEM file


data "aws_ssm_parameter" "sg_id" {
  name = "/VSH/SG/ID"
}

resource "tls_private_key" "priv_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.key_name}"
  public_key = "${tls_private_key.priv_key.public_key_openssh}"
}

resource "aws_instance" "server" {
  instance_type          = "${var.instance_size}"
  ami                    = "${var.ami_id}"
  key_name               = "${aws_key_pair.generated_key.key_name}"
  get_password_data      = true
  vpc_security_group_ids = ["${data.aws_ssm_parameter.sg_id.value}"]
  tags = {
    Name = "VSH-${var.key_name}"
  }
}
