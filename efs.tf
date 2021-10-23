# Create EFS File System
resource "aws_efs_file_system" "efs" {
  tags =  {
    Name = "efs"
  }
  encrypted = true
  #kms_key_id = "${var.kms_arn}${aws_kms_key.kms.key_id}"
  #kms_key_id = "${aws_kms_key.kms.ARN}${aws_kms_key.kms.key_id}"
  #kms_key_id = "aws_kms_key.kms.key_id"
  kms_key_id = "${aws_kms_key.kms.arn}"
}

# Create and add two mount volume
resource "aws_efs_mount_target" "mounta" {
  file_system_id  = aws_efs_file_system.efs.id
  #subnet_id       = aws_subnet.private.id
  subnet_id       = aws_subnet.private_B[0].id
  security_groups = [aws_security_group.SG.id]
}

resource "aws_efs_mount_target" "mountb" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.private_B[1].id
  security_groups = [aws_security_group.SG.id]
}