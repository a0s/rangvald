resource "kubernetes_persistent_volume_claim" "db-pvc" {
  metadata {
    name = "db-pvc"
    namespace = var.namespace
    labels = {
      app = var.name
    }
  }
  spec {
    storage_class_name = "manual"
    access_modes = [
      "ReadWriteMany"]

    resources {
      requests = {
        storage = var.storage_capacity
      }
    }
  }
}
