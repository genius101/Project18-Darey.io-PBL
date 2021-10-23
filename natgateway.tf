# Create Elastic IP for NAT
resource "aws_eip" "nat_eip" {
  count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets   
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
  # tags = merge(
  #   var.additional_tags,
  #   {
  #     Name = format("EIP-%s",aws_eip.nat_eip[count.index].id)
  #   } 
  # )
}

  #Create NAT Gateway 
  resource "aws_nat_gateway" "nat" {
  count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets   
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  #subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.ig]
  # tags = merge(
  #   var.additional_tags,
  #   {
  #     Name   =  format("Nat-%s",aws_nat_gateway.nat[count.index].id)
  #   } 
  # )
}

# Create aws_route_table for Private Subnet A
resource "aws_route_table" "private_A" {
  count = var.preferred_number_of_private_subnets_A == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_private_subnets_A
  vpc_id = aws_vpc.main.id
  #   tags = {
  #   Name        =  format("PrivateA-RT, %s!", aws_route_table.private_A[count.index])
  # }
}

# Create aws_route for Private Subnet A
resource "aws_route" "private_A" {
  count = var.preferred_number_of_private_subnets_A == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_private_subnets_A
  route_table_id         = aws_route_table.private_A[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}

# Create aws_route_table_association for Private Subnet A
resource "aws_route_table_association" "private_A" {
  count = var.preferred_number_of_private_subnets_A == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_private_subnets_A
  subnet_id      = aws_subnet.private_A[count.index].id
  route_table_id = aws_route_table.private_A[count.index].id
}

# Create aws_route_table for Private Subnet B
resource "aws_route_table" "private_B" {
  count = var.preferred_number_of_private_subnets_B == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_private_subnets_B
  vpc_id = aws_vpc.main.id
  #   tags = {
  #   Name        =  format("privateB-RT, %s!",aws_route_table.private_B[count.index])
  # }
}

# Create aws_route for Private Subnet B
resource "aws_route" "private_B" {
  count = var.preferred_number_of_private_subnets_B == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_private_subnets_B
  route_table_id         = aws_route_table.private_B[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}

# Create aws_route_table_association for Private Subnet B
resource "aws_route_table_association" "private_B" {
  count = var.preferred_number_of_private_subnets_B == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_private_subnets_B
  subnet_id      = aws_subnet.private_B[count.index].id
  route_table_id = aws_route_table.private_B[count.index].id
}
