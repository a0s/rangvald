output "external_port" {
  value = kubernetes_service.api-svc.spec[0].port[0].port
}
