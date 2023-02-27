provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-east-1"
}

resource "aws_instance" "ec2-windows-nodes" {
  ami       = "ami-024614f01f42eeb66"
  instance_type = "t2.micro"
  count = 1
  key_name = "key-unyleya"
  
  tags = {
       Name = "Cluster ${count.index}"
  }
}

resource "aws_security_group" "ec2-windows-node" {
  name = "web-node"
  description = "Web Security Group"
    ingress {
        from_port = 3389
        to_port = 3389
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 5985
        to_port = 5985
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 5986
        to_port =  5986
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        type = "k8s-security-group"
    }
}

resource "aws_network_interface_sg_attachment" "k8s_attachment" {
    count = 1
    security_group_id = aws_security_group.ec2-windows-node.id
    network_interface_id = aws_instance.ec2-windows-nodes[count.index].primary_network_interface_id
}
