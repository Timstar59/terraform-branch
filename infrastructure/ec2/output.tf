output "prod_ip" {
  value = aws_instance.docker_instance.public_ip[0]
}
output "test_ip" {
  value = aws_instance.docker_instance.public_ip[1]
}
output "jenk_ip" {
  value = aws_instance.jenkins.public_ip
}