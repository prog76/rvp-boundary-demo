variable "keycloak_host" {
  type    = string
  default = "http://keycloak.localhost:8080"
}

variable "boundary_host" {
  type    = string
  default = "http://boundary.localhost:9200"
}

variable "vault_host" {
  type    = string
  default = "http://vault.localhost:8200"
}

variable "vault_docker_dns" {
  type    = string
  default = "http://vault.localhost:8200"
}

variable "oauth_client_id" {
  type    = string
}

variable "oauth_client_secret" {
  type    = string
}