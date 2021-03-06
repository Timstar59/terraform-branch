provider "aws" {
    region = "eu-west-2"
    access_key = var.access_key
    secret_key = var.secret_key
}

module "vpc" {
    source          = "./vpc"
}
module "subnets" {
    source          = "./subnets"
    
    vpc_id          = module.vpc.vpc_id
    route_id        = module.vpc.route_id
    sec_group_id    = module.vpc.sec_group_id
    internet_gate   = module.vpc.internet_gate
}

module "ec2" {
    source          = "./ec2"
    net_id_prod     = module.subnets.net_id_prod
    net_id_test     = module.subnets.net_id_test
    net_id_jenk     = module.subnets.net_id_jenk
    ami_id          = "ami-096cb92bb3580c759"
    instance_type   = "t2.medium"
    av_zone         = "eu-west-2a"
    key_name        = "terraforminit"
    sec_group_id    = module.vpc.db_sec_group_id
    subnet_group_name = module.subnets.db_subnet_group
    db_password     = var.db_password
}

resource "local_file" "tf_ansible_inventory" {
  content = <<-DOC
    [jenkins]

    ${module.ec2.jenk_ip} ansible_ssh_private_key_file=~/.ssh/terraforminit.pem

    [swarmmaster]

    ${module.ec2.prod_ip} ansible_ssh_private_key_file=~/.ssh/terraforminit.pem

    [swarmtest]

    ${module.ec2.test_ip} ansible_ssh_private_key_file=~/.ssh/terraforminit.pem

    [swarmmaster:vars]

    ansible_user=ubuntu

    ansible_ssh_common_args='-o StrictHostKeyChecking=no'

    db_ip=${module.subnets.NAT_publicIP}

    [swarmtest:vars]

    ansible_user=ubuntu

    ansible_ssh_common_args='-o StrictHostKeyChecking=no'

    db_ip=${module.subnets.NAT_publicIP}

    [jenkins:vars]

    ansible_user=ubuntu

    ansible_ssh_common_args='-o StrictHostKeyChecking=no'
    DOC
  filename = "./inventory"
}

resource "local_file" "tf_Jenkinsfile" {
  content = <<-DOC
    pipeline{
                agent any
                stages{
                        stage('--Front End--'){
                                steps{
                                        sh '''
                                                image="${module.ec2.jenk_ip}:5000/frontend:build-$BUILD_NUMBER"
                                                docker build -t $image /var/lib/jenkins/workspace/DnD_master/frontend
                                                docker push $image
                                                ssh ${module.ec2.prod_ip} -oStrictHostKeyChecking=no  << EOF
                                                docker service update --image $image DnDCharacterGen_frontend
                                        '''
                                }
                        }  
                        stage('--Service1--'){
                                steps{
                                        sh '''
                                                image="${module.ec2.jenk_ip}:5000/rand1:build-$BUILD_NUMBER"
                                                docker build -t $image /var/lib/jenkins/workspace/DnD_master/randapp1
                                                docker push $image
                                                ssh ${module.ec2.prod_ip} -oStrictHostKeyChecking=no  << EOF
                                                docker service update --image $image DnDCharacterGen_service1
                                        '''
                                }
                        }
                        stage('--Service2--'){
                                steps{
                                        sh '''
                                                image="${module.ec2.jenk_ip}:5000/rand2:build-$BUILD_NUMBER"
                                                docker build -t $image /var/lib/jenkins/workspace/DnD_master/randapp2
                                                docker push $image
                                                ssh ${module.ec2.prod_ip} -oStrictHostKeyChecking=no  << EOF
                                                docker service update --image $image DnDCharacterGen_service2
                                        '''
                                }
                        }
                        stage('--Back End--'){
                                steps{
                                        sh '''
                                                image="${module.ec2.jenk_ip}:5000/backend:build-$BUILD_NUMBER"
                                                docker build -t $image /var/lib/jenkins/workspace/DnD_master/backend
                                                docker push $image
                                                ssh ${module.ec2.prod_ip} -oStrictHostKeyChecking=no  << EOF
                                                docker service update --image $image DnDCharacterGen_backend
                                        '''
                                }
                        }
                        stage('--Clean up--'){
                                steps{
                                        sh '''
                                                ssh ${module.ec2.prod_ip} -oStrictHostKeyChecking=no  << EOF
                                                docker system prune
                                        '''
                                }
                        }
                }
        }
    DOC
  filename = "../Jenkinsfile"
}

resource "local_file" "tf_DockerCompose" {
  content = <<-DOC
version: '3.7'
services:
    nginx:
      image: nginx:latest
      ports:
        - target: 80
          published: 80
          protocol: tcp
      volumes:
        - type: bind
          source: ./nginx/nginx.conf
          target: /etc/nginx/nginx.conf
      depends_on:
        - frontend

    frontend:
      image: jenkins:5000/frontend:build-0
      build: ./frontend
      ports:
        - target: 5000
          published: 5000
      environment:
        - MYSQL_USER=root
        - MYSQL_PWD=$${DB_PWD}
        - MYSQL_IP=${module.subnets.NAT_publicIP}
        - MYSQL_DB=DnD
        - MYSQL_SK=sgjbsloiyblvbda
    
    service1:
      image: jenkins:5000/rand1:build-0
      build: ./randapp1
      ports:
        - target: 5001
          published: 5001
      
    service2:
      image: jenkins:5000/rand2:build-0
      build: ./randapp2
      ports:
        - target: 5002
          published: 5002

    backend:
      image: jenkins:5000/backend:build-0
      build: ./backend
      ports:
        - target: 5003
          published: 5003
    DOC
  filename = "../docker-compose.yaml"
}
resource "local_file" "tf_InsecureRegistry" {
  content = <<-DOC

{
        "insecure-registries":["${module.ec2.jenk_ip}:5000"]
}
    DOC
  filename = "./daemon.json"
}
