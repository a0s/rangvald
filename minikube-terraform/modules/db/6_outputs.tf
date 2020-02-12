output "db_host" {
  value = kubernetes_service.db-svc.metadata[0].name
}

output "db_port" {
  value = kubernetes_service.db-svc.spec[0].port[0].port
}
