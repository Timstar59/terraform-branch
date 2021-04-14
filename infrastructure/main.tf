provider "aws" {
    region = "eu-west-2"
    access_key = var.access_key
    secret_key = var.secret_key
}

resource "local_file" "tf_ansible_inventory" {
  content = <<-DOC
    [jenkins]

    ${module.ec2.jenk_ip} ansible_ssh_private_key_file=~/.ssh/Terraform-Resource

    [swarmmaster]

    ${module.ec2.prod_ip} ansible_ssh_private_key_file=~/.ssh/Terraform-Resource
    ${module.ec2.test_ip} ansible_ssh_private_key_file=~/.ssh/Terraform-Resource

    [swarmmaster:vars]

    ansible_user=ubuntu

    ansible_ssh_common_args='-o StrictHostKeyChecking=no'

    [jenkins:vars]

    ansible_user=ubuntu

    ansible_ssh_common_args='-o StrictHostKeyChecking=no'
    DOC
  filename = "./inventory"
}


module "ec2" {
    source          = "./ec2"

    net_id          = module.subnets.net_id
    ami_id          = "ami-096cb92bb3580c759"
    instance_type   = "t2.medium"
    av_zone         = "eu-west-2a"
    key_name        = "Terraform-Resource"
}
module "subnets" {
    source          = "./subnets"
    
    vpc_id          = module.vpc.vpc_id
    route_id        = module.vpc.route_id
    sec_group_id    = module.vpc.sec_group_id
    net_private_ips = ["10.0.1.50", "10.0.1.51", "10.0.1.52"]
    internet_gate   = module.vpc.internet_gate
}
module "vpc" {
    source          = "./vpc"
}