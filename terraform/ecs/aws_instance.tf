# ECS-optimize AMIのidをネットから取得
# data aws_ssm_parameter amzn2_ami {
#   name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
# }
# ami                         = data.aws_ssm_parameter.amzn2_ami.value

resource "aws_instance" "sample" {
  ami                         = "ami-0633805928291a0db"
  instance_type               = "t2.small"
  monitoring                  = true
  iam_instance_profile        = aws_iam_instance_profile.ecs_instance_profile.name
  subnet_id                   = aws_subnet.public_subnet_1.id
  user_data                   = file("./user_data.sh")
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.instance.id,
  ]

  root_block_device {
    volume_size = "30"
    volume_type = "gp2"
  }
}