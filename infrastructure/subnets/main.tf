resource "aws_subnet" "subnet-1" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "prod-subnet"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = var.route_id
}

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = var.net_private_ips
  security_groups = [var.sec_group_id]
}
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = var.net_private_ips[0]
  depends_on                = [var.internet_gate]
}

resource "aws_eip" "two" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = var.net_private_ips[1]
  depends_on                = [var.internet_gate]
}

resource "aws_eip" "three" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = var.net_private_ips[2]
  depends_on                = [var.internet_gate]
}