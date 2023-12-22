/*--------------- Bastion SG ---------------*/

resource "aws_security_group" "bastion-SG" {
  name        = var.bastion_sg_name
  description = "SG for bastion server"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.public_ingress_ports
    iterator = ingress_port
    content {
      from_port   = ingress_port.value
      protocol    = "TCP"
      to_port     = ingress_port.value
      cidr_blocks = ["0.0.0.0/0"]

    }
  }
    ingress {
    from_port   = -1  
    to_port     = -1  
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
    
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*--------------- Private SG ---------------*/

resource "aws_security_group" "private-SG" {
  name        = var.private_sg_name
  description = "SG for private server"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.private_ingress_ports
    iterator = ingress_port
    content {
      from_port   = ingress_port.value
      protocol    = "TCP"
      to_port     = ingress_port.value
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

   ingress {
    from_port   = -1  
    to_port     = -1  
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
    
  }
  
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*--------------- Key Pair ---------------*/

resource "aws_key_pair" "key-pair-01" {
  key_name   = var.key_pair
  public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "key-01" {
  content         = tls_private_key.rsa.private_key_pem
  file_permission = "0400"
  filename        = "${var.key_pair}.pem"
}

/*--------------- Bastion Instance ---------------*/

resource "aws_instance" "bastion_instance" {
  ami                    = var.ami_id 
  instance_type          = var.bastion_instance_type
  subnet_id              = var.bastion_instance_subnet_id
  key_name               = var.key_pair 
  vpc_security_group_ids = [aws_security_group.bastion-SG.id]
  depends_on             = [aws_security_group.bastion-SG]
  tags = {
    Name = var.bastion_instance_name
  }
}

/*--------------- Private Instance ---------------*/


resource "aws_instance" "private_instance_01"{
  
  ami                    = var.ami_id
  instance_type          = var.private_instance_type
  subnet_id              = var.private_instance_subnet_id[0]
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.private-SG.id]
  depends_on             = [aws_security_group.private-SG]
tags = {
    Name = "${var.private_instance_name}-01"
    group = "master_nodes"
  }
}

resource "aws_instance" "private_instance_02" {
  
  ami                    = var.ami_id
  instance_type          = var.private_instance_type
  subnet_id              = var.private_instance_subnet_id[1]
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.private-SG.id]
  depends_on             = [aws_security_group.private-SG]
tags = {
    Name = "${var.private_instance_name}-02"
    group = "master_nodes"
  }
}

/*--------------- Target Group ---------------*/

resource "aws_lb_target_group" "opensearch" {
  name     = "opensearch"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

/*--------------- Target Group Attachment ---------------*/

resource "aws_lb_target_group_attachment" "opensearch_attcmt01" {
  target_group_arn = aws_lb_target_group.opensearch.arn
  target_id        = aws_instance.private_instance_01.id
  port             = 5601
}

resource "aws_lb_target_group_attachment" "opensearch_attcmt02" {
  target_group_arn = aws_lb_target_group.opensearch.arn
  target_id        = aws_instance.private_instance_02.id
  port             = 5601
}

/*--------------- ALB ---------------*/

resource "aws_lb" "opensearch_alb" {
  name               = "opensearch-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private-SG.id]
  subnets            = var.public_subnet_id

  enable_deletion_protection = false

  tags = {
    Environment = "opensearch"
  }
}

output "alb_dns_name" {
  value       = aws_lb.opensearch_alb.dns_name
  description = "opensearch alb dns name"
  depends_on  = [aws_lb.opensearch_alb]
}

/*--------------- ALB Listener ---------------*/

resource "aws_lb_listener" "opensearch" {
  load_balancer_arn = aws_lb.opensearch_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.opensearch.arn
    type             = "forward"
  }
}