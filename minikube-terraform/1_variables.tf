variable "kube_host" {
  default = "https://kubernetes.docker.internal:6443"
}

variable "kube_config_path" {
  default = "~/.kube/config"
}

variable "kube_config_context" {
  default = "docker-desktop"
}

variable "namespace" {
  default = "rangvald"
}

variable "db_name" {
  default = "somedb"
}

variable "db_user" {
  default = "someusername"
}

variable "db_password" {
  default = "somepassword"
}

variable "db_volume_size" {
  default = "5G"
}

variable "db_image" {
  default = "postgres:12.1-alpine"
}

variable "db_initial_delay_seconds" {
  default = 10
}

variable "db_failure_threshold" {
  default = 1
}

variable "db_period_seconds" {
  default = 5
}

variable "api_pods_count" {
  default = 3
}

variable "api_image" {
  default = "django-todo:latest"
}

variable "api_initial_delay_seconds" {
  default = 5
}

variable "api_failure_threshold" {
  default = 1
}

variable "api_period_seconds" {
  default = 5
}

variable "api_external_port" {
  default = 8080
}
