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
      storage = var.storage_capacity
    }
    persistent_volume_source {
      host_path {
        path = "/data/${var.namespace}-db-${var.name}"
      }
    }
  }
}
