resource "yandex_vpc_network" "main" {
  name = "diploma-network"
}

# Публичная подсеть (для bastion, Zabbix, Kibana, ALB)
resource "yandex_vpc_subnet" "public_a" {
  name           = "public-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.10.0.0/24"]
}

# Приватные подсети (web + Elasticsearch)
resource "yandex_vpc_subnet" "private_a" {
  name           = "private-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.10.1.0/24"]
  route_table_id = yandex_vpc_route_table.private.id
}

resource "yandex_vpc_subnet" "private_b" {
  name           = "private-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.10.2.0/24"]
  route_table_id = yandex_vpc_route_table.private.id
}

# NAT-шлюз для исходящего интернета из приватных подсетей
resource "yandex_vpc_gateway" "nat" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "private" {
  name       = "private-route"
  network_id = yandex_vpc_network.main.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat.id
  }
}
