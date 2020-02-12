module "db" {
  source = "./modules/db"

  name = "postgres"
  namespace = kubernetes_namespace.namespace.metadata[0].name
  storage_capacity = var.db_volume_size
  image = var.db_image
  image_pull_policy = "IfNotPresent"

  db_name = var.db_name
  db_user = var.db_user
  db_password = var.db_password

  initial_delay_seconds = var.db_initial_delay_seconds
  failure_threshold = var.db_failure_threshold
  period_seconds = var.db_period_seconds
}


module "api" {
  source = "./modules/api"

  name = "django-todo"
  namespace = kubernetes_namespace.namespace.metadata[0].name
  replicas = var.api_pods_count
  image = var.api_image
  image_pull_policy = "Never"

  db_name = var.db_name
  db_user = var.db_user
  db_password = var.db_password
  db_host = module.db.db_host
  db_port = module.db.db_port

  initial_delay_seconds = var.api_initial_delay_seconds
  failure_threshold = var.api_failure_threshold
  period_seconds = var.api_period_seconds

  external_port = var.api_external_port
}
