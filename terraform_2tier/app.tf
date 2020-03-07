resource "aws_instance" "appserver" {
  ami = "ami-0c28d7c6dd94fb3a7"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.appsg.name}"]

  tags = {
    Name = "AppServer"
  }
}

resource "aws_eip" "appip" {
    instance = aws_instance.appserver.id
}
resource "aws_security_group" "appsg" {
  name = "appserver-sg" 
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.webeip.public_ip}/32"]
   }

  ingress {
    from_port   = 80 
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.webeip.public_ip}/32"]
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

output "appip" {
  value = aws_eip.appip.public_ip
}

