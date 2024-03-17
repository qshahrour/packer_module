resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = aws_vpc.main.ipv6_cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "example" {
  # ... other configuration ...

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "example" {
  # ... other configuration ...

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    prefix_list_ids = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
  }
}

resource "aws_vpc_endpoint" "my_endpoint" {
  # ... other configuration ...
}

resource "aws_security_group" "example" {
  name   = "sg"
  vpc_id = aws_vpc.example.id

  ingress = []
  egress  = []
}

resource "aws_security_group" "example" {
  name = "changeable-name"
  # ... other configuration ...

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "example" {
  name = "sg"
  # ... other configuration ...
}

resource "aws_instance" "example" {
  instance_type = "t3.small"
  # ... other configuration ...

  vpc_security_group_ids = [aws_security_group.test.id]

  lifecycle {
    # Reference the security group as a whole or individual attributes like `name`
    replace_triggered_by = [aws_security_group.example]
  }
}

resource "aws_security_group" "example" {
  name = "izizavle"
  # ... other configuration ...

  timeouts {
    delete = "2m"
  }
}

data "aws_security_group" "default" {
  name = "default"
  # ... other configuration ...
}

resource "aws_security_group" "example" {
  name = "sg"
  # ... other configuration ...

  # The downstream resource must have at least one SG attached, therefore we
  # attach the default SG of the VPC temporarily and remove it later on
  provisioner "local-exec" {
    when       = destroy
    command    = <<DOC
            ENDPOINT_ID=`aws ec2 describe-vpc-endpoints --filters "Name=tag:Name,Values=${self.tags.workaround1}" --query "VpcEndpoints[0].VpcEndpointId" --output text` &&
            aws ec2 modify-vpc-endpoint --vpc-endpoint-id $${ENDPOINT_ID} --add-security-group-ids ${self.tags.workaround2} --remove-security-group-ids ${self.id}
        DOC
    on_failure = continue
  }

  tags = {
    workaround1 = "tagged-name"
    workaround2 = data.aws_security_group.default.id
  }
}

resource "null_resource" "example" {
  provisioner "local-exec" {
    command    = <<DOC
            aws ec2 modify-vpc-endpoint --vpc-endpoint-id ${aws_vpc_endpoint.example.id} --remove-security-group-ids ${data.aws_security_group.default.id}
        DOC
    on_failure = continue
  }

  triggers = {
    rerun_upon_change_of = join(",", aws_vpc_endpoint.example.security_group_ids)
  }
}
