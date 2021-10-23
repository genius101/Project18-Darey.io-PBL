#Create a Keypair
resource "aws_key_pair" "habeebejio" {
  key_name   = "habeebejio"
  public_key = file("/Users/habeebejio/.ssh/id_rsa.pub")
}