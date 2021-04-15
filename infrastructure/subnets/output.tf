# output "NAT_publicIP" {
#   value = aws_eip.Nat-Gateway-EIP.public_ip
# }
output "net_id" {
  value = aws_network_interface.web-server-nic.id
}