provider "kubernetes" {
  host = var.kube_host
  config_path = var.kube_config_path
  config_context = var.kube_config_context
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
  }
}
