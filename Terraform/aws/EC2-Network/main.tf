provider "aws" {
  region = "eu-central-1"
}


resource "aws_instance" "avl_webserver" {
  ami                    = "ami-0084a47cc718c111a"
  instance_type          = "t2.micro"
  key_name               = "aws-1"
  vpc_security_group_ids = [aws_security_group.my_avl_security.id]
  subnet_id              = aws_subnet.my_subnet.id
  user_data              = file("user-data.sh")

  tags = {
    Name = var.instance_name
  }


}

resource "aws_eip" "avl_static_ip" {
  instance = aws_instance.avl_webserver.id

  tags = {
    Name = "my_static"
  }
}
