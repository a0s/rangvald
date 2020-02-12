resource "kubernetes_deployment" "api" {
  metadata {
    name = "api"
    namespace = var.namespace

    labels = {
      app = var.name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "api"
      }
    }

    template {
      metadata {
        labels = {
          app = "api"
        }
      }
      spec {
        init_container {
          name = "migrator"
          image = var.image
          image_pull_policy = var.image_pull_policy

          env {
            name = "DB_NAME"
            value = var.db_name
          }

          env {
            name = "DB_USER"
            value = var.db_user
          }

          env {
            name = "DB_PASSWORD"
            value = var.db_password
          }

          env {
            name = "DB_HOST"
            value = var.db_host
          }

          env {
            name = "DB_PORT"
            value = var.db_port
          }

          command = [
            "python"]

          args = [
            "manage.py",
            "migrate"]
        }

        container {
          name = "main"
          image = var.image
          image_pull_policy = var.image_pull_policy

          env {
            name = "DB_NAME"
            value = var.db_name
          }

          env {
            name = "DB_USER"
            value = var.db_user
          }

          env {
            name = "DB_PASSWORD"
            value = var.db_password
          }

          env {
            name = "DB_HOST"
            value = var.db_host
          }

          env {
            name = "DB_PORT"
            value = var.db_port
          }

          command = [
            "python"]

          args = [
            "manage.py",
            "runserver",
            "0.0.0.0:8000"]

          port {
            name = "http"
            container_port = 8000
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "8000"
            }

            initial_delay_seconds = var.initial_delay_seconds
            failure_threshold = var.failure_threshold
            period_seconds = var.period_seconds
          }
        }
      }
    }
  }
}
