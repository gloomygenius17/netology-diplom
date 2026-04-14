resource "yandex_vpc_security_group" "bastion" {
  name       = "bastion-sg"
  network_id = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "SSH from anywhere"
  }

  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = ["10.10.0.0/24"]
    description    = "Allow all from public subnet"
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "public" {
  name       = "public-sg"
  network_id = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["10.10.0.0/24"]
    description    = "SSH from bastion"
  }
  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "HTTP from anywhere (ALB)"
  }
  ingress {
    protocol       = "TCP"
    port           = 10051
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Zabbix server web UI"
  }
  ingress {
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Kibana web UI"
  }
  ingress {
    protocol       = "TCP"
    port           = 10050
    v4_cidr_blocks = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
    description    = "Zabbix agent from all subnets"
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "private" {
  name       = "private-sg"
  network_id = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["10.10.0.0/24"]
    description    = "HTTP from ALB subnet"
  }
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
    description    = "SSH from bastion and web subnets"
  }
  ingress {
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
    description    = "Elasticsearch from public and web subnets"
  }
  ingress {
    protocol       = "TCP"
    port           = 10050
    v4_cidr_blocks = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
    description    = "Zabbix agent from all subnets"
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
