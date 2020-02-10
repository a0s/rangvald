resource "kubernetes_persistent_volume" "pv" {
  metadata {
    name = "pv"
    //    namespace = var.namespace # BUG IS HERE
  }
  spec {
    storage_class_name = "manual"
    access_modes = [
      "ReadWriteMany"]
    capacity = {
      storage = var.db_volume_size
    }
    persistent_volume_source {
      host_path {
        path = "/data/${var.namespace}-db"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "db-pvc" {
  metadata {
    name = "db-pvc"
    namespace = var.namespace
    labels = {
      app = "postgres"
    }
  }
  spec {
    storage_class_name = "manual"
    access_modes = [
      "ReadWriteMany"]

    resources {
      requests = {
        storage = var.db_volume_size
      }
    }
  }
}

resource "kubernetes_deployment" "db" {
  metadata {
    name = "db"
    namespace = var.namespace
    labels = {
      app = "postgres"
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name = "postgres"
          image = var.db_image

          port {
            name = "postgres"
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
            name = "postgredb"
          }

          readiness_probe {
            tcp_socket {
              port = "postgres"
            }
            initial_delay_seconds = var.db_initial_delay_seconds
            failure_threshold = var.db_failure_threshold
            period_seconds = var.db_period_seconds
          }
        }

        volume {
          name = "postgredb"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.db-pvc.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "db-svc" {
  metadata {
    name = "db"
    namespace = var.namespace
    labels = {
      app = "postgres"
    }
  }

  spec {
    selector = {
      app = "postgres"
    }

    type = "ClusterIP"

    port {
      port = 5432
    }
  }
}
