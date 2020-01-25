resource "aws_key_pair" "key_pair" {
  key_name   = "weinance-ecs-key"
  public_key = file("~/ssh_keys/example.id_rsa.pub")
}