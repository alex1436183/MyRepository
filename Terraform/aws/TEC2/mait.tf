provider "aws" {
  region = "eu-central-1" 
}

resource "aws_instance" "avl_ubuntu1" {
  ami           = "ami-0084a47cc718c111a"
  instance_type = "t2.micro"
  key_name      = "aws-1"
  subnet_id     = "subnet-0e8f515b5b7d37744"
  security_groups = ["sg-0c0035be96ba711b7"]

  tags = {
    Name = "avl_ubuntu1"
  }
}

resource "aws_ami_from_instance" "my_ubuntu_1" {
  name               = "MyUbuntu_1"
  source_instance_id = aws_instance.avl_ubuntu1.id
}

resource "aws_launch_template" "my_ubuntu_tem1" {
  name_prefix = "my-ubuntu-tem1"

  image_id      = aws_ami_from_instance.my_ubuntu_1.id
  instance_type = "t2.micro"

  network_interfaces {
    security_groups = ["sg-0c0035be96ba711b7"]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "my-ubuntu-tem_1"
    }
  }
}

resource "aws_autoscaling_group" "ubuntu_asg" {
  desired_capacity     = 2
  max_size             = 2
  min_size             = 1
  vpc_zone_identifier  = ["subnet-03207db2b91a2a05e", "subnet-00669df1cc78cf133"]
  launch_template {
    id      = aws_launch_template.my_ubuntu_tem1.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "scale-out-policy"
  scaling_adjustment      = 1
  adjustment_type         = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ubuntu_asg.name
}
