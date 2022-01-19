# variable "gcp_billing_account_name" {}

variable "gcp_billing_account_id" {
  type = string
}

variable "gcp_project_editors" {
  type    = list(string)
  default = []
}

variable "gcp_project_id" {
  type = string
}

variable "gcp_project_name" {
  type = string
}

variable "gcp_project_owners" {
  type    = list(string)
  default = []
}

variable "gcp_region" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "squarespace_api_key" {
  sensitive = true
}

variable "oauth_client_id" {
  sensitive = true
}

variable "oauth_client_secret" {
  sensitive = true
}
