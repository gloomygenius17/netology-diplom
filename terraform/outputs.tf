output "bastion_public_ip" {
  value = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
  description = "Public IP of bastion host"
}

output "alb_public_ip" {
  value = yandex_alb_load_balancer.web_alb.listener[0].endpoint[0].address[0].external_ipv4_address
  description = "Public IP of Application Load Balancer"
}

output "zabbix_public_ip" {
  value = yandex_compute_instance.zabbix.network_interface[0].nat_ip_address
  description = "Public IP of Zabbix server"
}

output "kibana_public_ip" {
  value = yandex_compute_instance.kibana.network_interface[0].nat_ip_address
  description = "Public IP of Kibana"
}

output "web1_private_ip" {
  value = yandex_compute_instance.web1.network_interface[0].ip_address
  description = "Private IP of web1"
}

output "web2_private_ip" {
  value = yandex_compute_instance.web2.network_interface[0].ip_address
  description = "Private IP of web2"
}

output "elasticsearch_private_ip" {
  value = yandex_compute_instance.elasticsearch.network_interface[0].ip_address
  description = "Private IP of Elasticsearch"
}
