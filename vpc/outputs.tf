output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_arn" {
  value = aws_vpc.this.arn
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public_subnet[*]: subnet.id]
}

output "public_subnet_cidr_blocks" {
  value = [for subnet in aws_subnet.public_subnet[*]: subnet.cidr_block]
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_subnet[*]: subnet.id]
}

output "private_subnet_cidr_blocks" {
  value = [for subnet in aws_subnet.private_subnet[*]: subnet.cidr_block]
}