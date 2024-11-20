output "ec2-public-ip" {
  value = aws_instance.web-server.public_ip
  description = "webserver public ip"
}


output "ec2-instace-id" {
  value = aws_instance.web-server.id
  description = "web-server instace id"
}