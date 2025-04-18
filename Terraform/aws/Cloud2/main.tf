provider "aws" {
  region = "eu-central-1"
}

resource "aws_key_pair" "ec2_ssh_key" {
  key_name   = "terra_key"
  public_key = file("${path.module}/terra_key.pub")
}

resource "aws_instance" "avl_ec2" {
  ami                    = "ami-07eef52105e8a2059"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ec2_ssh_key.key_name
  vpc_security_group_ids = ["sg-0c0035be96ba711b7"]

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = "terraform-ubuntu24"
  }
}

resource "aws_ebs_volume" "my_ebs" {
  availability_zone = aws_instance.avl_ec2.availability_zone
  size              = 5
  type              = "gp3"
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.my_ebs.id
  instance_id = aws_instance.avl_ec2.id
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-s3-terraform-avl"
}

resource "aws_s3_object" "my_files" {
  for_each = fileset("./upload", "*")
  bucket   = aws_s3_bucket.my_bucket.id
  key      = each.value
  source   = "./upload/${each.value}"
}
