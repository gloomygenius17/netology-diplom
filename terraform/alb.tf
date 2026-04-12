# Target Group (веб-серверы)
resource "yandex_alb_target_group" "web_tg" {
  name = "web-target-group"

  target {
    subnet_id  = yandex_vpc_subnet.private_a.id
    ip_address = yandex_compute_instance.web1.network_interface[0].ip_address
  }
  target {
    subnet_id  = yandex_vpc_subnet.private_b.id
    ip_address = yandex_compute_instance.web2.network_interface[0].ip_address
  }
}

# Backend Group
resource "yandex_alb_backend_group" "web_bg" {
  name = "web-backend-group"

  http_backend {
    name             = "web-backend"
    target_group_ids = [yandex_alb_target_group.web_tg.id]
    port             = 80          # <-- ПОРТ УКАЗЫВАЕТСЯ ЗДЕСЬ
    weight           = 1

    healthcheck {
      timeout             = "5s"
      interval            = "10s"
      healthy_threshold   = 3
      unhealthy_threshold = 3

      http_healthcheck {
        path = "/"
        # port не нужен, наследуется от http_backend
      }
    }

    load_balancing_config {
      panic_threshold = 50
    }
  }
}

# HTTP Router
resource "yandex_alb_http_router" "web_router" {
  name = "web-http-router"
}

resource "yandex_alb_virtual_host" "main" {
  name           = "main-host"
  http_router_id = yandex_alb_http_router.web_router.id

  route {
    name = "root-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web_bg.id
        timeout          = "10s"
      }
    }
  }
}

# Application Load Balancer
resource "yandex_alb_load_balancer" "web_alb" {
  name        = "web-application-lb"
  network_id  = yandex_vpc_network.main.id
  description = "Load balancer for web servers"

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.public_a.id
    }
  }

  listener {
    name = "http-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.web_router.id
      }
    }
  }
}
