# Allow traffic from the node SG to the master SG
resource "aws_security_group_rule" "allow_node_to_master" {
    type              = "ingress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    security_group_id = aws_security_group.master.id
    source_security_group_id = aws_security_group.node.id
}
