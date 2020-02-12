resource "kubernetes_service" "api-svc" {
  metadata {
    name = "api"
    namespace = var.namespace

    labels = {
      app = var.name
    }
  }

  spec {
    selector = {
      app = "api"
    }

    type = "LoadBalancer"

    port {
      port = var.external_port
      target_port = 8000
    }
  }
}
