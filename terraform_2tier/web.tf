resource "aws_instance" "webserver" {
  ami = "ami-0c28d7c6dd94fb3a7"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.websg.name}"]

  tags = {
    Name = "WebServer"
  }
}

resource "aws_eip" "webeip" {
  instance = aws_instance.webserver.id
}

resource "aws_security_group" "websg" {
  description = "Allow TLS inbound traffic"
  name = "web-server-sg"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }

  ingress {
    from_port   = 80 
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["116.75.30.5/32"]
   }

  ingress {
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["116.75.30.5/32"]
   }

  ingress {
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["116.75.30.5/32"]    
   }
}

output "web-eip" {
  value = aws_eip.webeip.public_ip

}
