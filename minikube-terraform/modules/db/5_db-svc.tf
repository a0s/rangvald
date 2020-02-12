resource "kubernetes_service" "db-svc" {
  metadata {
    name = "db"
    namespace = var.namespace
    labels = {
      app = var.name
    }
  }

  spec {
    selector = {
      app = "db-${var.name}"
    }

    type = "ClusterIP"

    port {
      port = 5432
    }
  }
}
