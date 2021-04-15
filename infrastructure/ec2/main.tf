resource "aws_instance" "docker_instance" {
  ami               = var.ami_id 
  instance_type     = var.instance_type 
  availability_zone = var.av_zone 
  key_name          = var.key_name
  
  network_interface {
    device_index         = 0
    network_interface_id = var.net_id_prod
  }
  tags = {
    Name = "deployment"
  }
}
resource "aws_instance" "docker_instance_test" {
  ami               = var.ami_id 
  instance_type     = var.instance_type 
  availability_zone = var.av_zone 
  key_name          = var.key_name
  
  network_interface {
    device_index         = 0
    network_interface_id = var.net_id_test
  }
  tags = {
    Name = "test"
  }
}
resource "aws_instance" "jenkins" {
  ami               = var.ami_id 
  instance_type     = var.instance_type 
  availability_zone = var.av_zone 
  key_name          = var.key_name

  network_interface {
    device_index         = 0
    network_interface_id = var.net_id_jenk
  }

  tags = {
    Name = "jenkins"
  }
}