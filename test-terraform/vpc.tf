# ==================================================
# VPC Resources
#  * VPC                =>  main-vpc
#  * Subnets            =>  main-subnet
#  * Internet Gateway   =>  main-igw
#  * Route Table        =>  main-route
# ==================================================

resource "aws_vpc" "main-vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = "${
    map(
      "Name", "${var.env}-VPC",
    )
  }"
}


resource "aws_subnet" "main-subnet" {
  count = 3

  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block              = "${var.subnet_cidr}.${count.index*64}/26"
  vpc_id                  = "${aws_vpc.main-vpc.id}"
  map_public_ip_on_launch = "false" //it makes this a private subnet

  tags = "${
    map(
      "Name", "${var.env}-Private-Subnet-0${count.index+1}"
    )
  }"
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id = "${aws_vpc.main-vpc.id}"

  tags = {
    Name = "${var.env}-IGW"
  }
}

resource "aws_route_table" "main-route" {
  vpc_id = "${aws_vpc.main-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main-igw.id}"
  }
}

resource "aws_route_table_association" "main" {
  count = 3

  subnet_id      = "${aws_subnet.demo.*.id[count.index]}"
  route_table_id = "${aws_route_table.main-route.id}"

}
