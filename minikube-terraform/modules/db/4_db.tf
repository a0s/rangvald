resource "kubernetes_deployment" "db" {
  metadata {
    name = "db"
    namespace = var.namespace
    labels = {
      app = var.name
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "db-${var.name}"
      }
    }

    template {
      metadata {
        labels = {
          app = "db-${var.name}"
        }
      }

      spec {
        container {
          name = "main"
          image = var.image
          image_pull_policy = var.image_pull_policy

          port {
            name = "primary"
            container_port = 5432
          }

          env {
            name = "POSTGRES_DB"
            value = var.db_name
          }

          env {
            name = "POSTGRES_USER"
            value = var.db_user
          }

          env {
            name = "POSTGRES_PASSWORD"
            value = var.db_password
          }

          volume_mount {
            mount_path = "/var/lib/postgresql/data"
            name = "data-volume"
          }

          readiness_probe {
            tcp_socket {
              port = "primary"
            }
            initial_delay_seconds = var.initial_delay_seconds
            failure_threshold = var.failure_threshold
            period_seconds = var.period_seconds
          }
        }

        volume {
          name = "data-volume"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.db-pvc.metadata[0].name
          }
        }
      }
    }
  }
}
