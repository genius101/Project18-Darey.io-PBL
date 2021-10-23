# EC2 Instances in Public Subnets
resource "aws_instance" "bastion" {
    count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets   
    key_name      = aws_key_pair.habeebejio.key_name
    ami           = var.ami
    instance_type = "t2.micro"
    vpc_security_group_ids = [
        aws_security_group.bastion_sg.id
    ]
    iam_instance_profile = aws_iam_instance_profile.ip.name
    #subnet_id     = aws_subnet.public.id
    subnet_id = element(aws_subnet.public.*.id,count.index)
    associate_public_ip_address = true
    source_dest_check = false
    user_data = <<-EOF
          #! /bin/bash
      echo "Hello from the other side"
    EOF
    tags = { 
          Name = "Bastion-Test${count.index}"
    }
}

# EC2 Instances in Private Subnets
resource "aws_instance" "private" {
    count  = var.preferred_number_of_private_subnets_A == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_private_subnets_A   
    key_name      = aws_key_pair.habeebejio.key_name
    ami           = var.ami
    instance_type = "t2.micro"
    vpc_security_group_ids = [
        aws_security_group.private_sg.id
    ]
    #subnet_id     = aws_subnet.private.id
    subnet_id = element(aws_subnet.private_A.*.id,count.index)
    associate_public_ip_address = false
    source_dest_check = false
    tags = {
        Name = "private-Test${count.index}"
    }
}