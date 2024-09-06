resource "aws_security_group" "master" {
    name = "${var.project}-master-sg"
    description = "security group for ${var.project}-kubernetes-master"
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        "Name" = "${var.project}-master-sg"
    }

    lifecycle {
      create_before_destroy = true
      ignore_changes = [ tags ]
    }
}

resource "aws_security_group" "node" {
    name = "${var.project}-node-sg"
    description = "security group for ${var.project}-kubernetes-node"
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        "Name" = "${var.project}-node-sg"
    }

    lifecycle {
      create_before_destroy = true
      ignore_changes = [ tags ]
    }
}
