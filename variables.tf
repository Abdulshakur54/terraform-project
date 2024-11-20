#VPC 

variable "vpc-name" {
  type = string
  default = "web"
  description = "Name of the VPC"
}

variable "vpc-cidr_block" {
  type = string
  default = "10.0.0.0/16"
  description = "VPC cidr block allowing us a possible 65,536 IP addresses"
}


#EC2

variable "ec2-instance-name" {
  type = string
  default = "web-server"
  description = "Name of the EC2 server"
}

variable "ec2-instance-type" {
  type = string
  default = "t2.micro"
  description = "EC2 instance type"
}

variable "ec2-user-data" {
  type = string
  default = <<-EOF
  #!/bin/bash -ex
  sudo -i
  yum update -y
  yum install -y nginx
  echo "<!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Launched From EC2</title>
            </head>
            <body>
                <h1>Brief description of Abdulshakur</h1>
                <p>
                  Hi, I am Abdulshakur. A Data Engineer | Cloud Engineer  
                </p>
                <p>Here is my  <a href="https://www.linkedin.com/in/abdulshakurmuhammed/" target="_blank">Linkedin profile</a></p>
                <p>Here is my  <a href=" https://www.credly.com/users/abdulshakur-muhammad" target="_blank">Credly profile</a></p>
                <p>Here is my  <a href="https://github.com/Abdulshakur54" target="_blank">Github profile</a></p>
            </body>
            </html>" > "/usr/share/nginx/html/index.html"
  systemctl enable nginx
  systemctl start nginx
  EOF
  description = "This contains some scripts that will be run when the EC2 instance is instantiated"
}