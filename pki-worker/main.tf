
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "worker" {
  ami                    = data.aws_ami.ubuntu.id
  name  =   "${var.prefix}-pki-worker"
  instance_type          = "t2.medium"
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.pki-worker_public.id]
  user_data              = file("./scripts/pki-worker.sh")
  key_name               = aws_key_pair.pkiworker.key_name
  tags = {
    Name = "${var.prefix}-pki-worker"
    Env  = var.env
  }
}



// Security Group

resource "aws_security_group" "pki-worker_public" {
  name        = "PKI Worker Public Allow"
  description = "PKI Worker Public Allow traffic"
  vpc_id      = module.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public Allow"
    Environment  = var.env
  }
}

