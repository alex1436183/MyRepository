
output "webserver_instanse_id" {
  value = aws_instance.avl_webserver.id
}

output "static_ip" {
  value = aws_eip.avl_static_ip.public_ip
}

output "security_group" {
  value = aws_security_group.my_avl_security.id
}

output "vpc" {
  value = aws_vpc.my-vpc.id
}
