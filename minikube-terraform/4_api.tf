resource "kubernetes_deployment" "api" {
  metadata {
    name = "api"
    namespace = var.namespace

    labels = {
      app = "django-todo"
    }
  }

  spec {
    replicas = var.api_pods_count

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
          image = var.api_image
          image_pull_policy = "Never"

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
            value = kubernetes_service.db-svc.metadata[0].name
          }

          env {
            name = "DB_PORT"
            value = kubernetes_service.db-svc.spec[0].port[0].port
          }

          command = [
            "python"]

          args = [
            "manage.py",
            "migrate"]
        }

        container {
          name = "app"
          image = var.api_image
          image_pull_policy = "Never"

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
            value = kubernetes_service.db-svc.metadata[0].name
          }

          env {
            name = "DB_PORT"
            value = kubernetes_service.db-svc.spec[0].port[0].port
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

            initial_delay_seconds = var.api_initial_delay_seconds
            failure_threshold = var.api_failure_threshold
            period_seconds = var.api_period_seconds
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "api-svc" {
  metadata {
    name = "api"
    namespace = var.namespace

    labels = {
      app = "django-todo"
    }
  }

  spec {
    selector = {
      app = "api"
    }

    type = "LoadBalancer"

    port {
      port = var.api_external_port
      target_port = 8000
    }
  }
}
