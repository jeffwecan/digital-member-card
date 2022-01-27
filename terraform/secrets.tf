resource "random_password" "flask_secret_key" {
  length  = 64
  special = false
}

resource "random_password" "sql_password" {
  length  = 64
  special = false
}


resource "google_secret_manager_secret" "digital_membership" {
  secret_id = "digital-membership"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "digital_membership" {
  secret = google_secret_manager_secret.digital_membership.id
  secret_data = jsonencode({
    # apple_pass_private_key          = var.apple_pass_private_key
    # sql_username                    = google_sql_user.service_account.name
    apple_pass_certificate          = var.apple_pass_certificate
    apple_pass_private_key_password = var.apple_pass_private_key_password
    sql_database_name               = google_sql_database.database.name
    sql_connection_name             = google_sql_database_instance.digital_membership.connection_name
    # sql_username                    = google_service_account.digital_membership.email
    # Note: Due to the length limit on a database username, for service accounts, Cloud SQL truncates the .gserviceaccount.com suffix in the email.
    # For example, the username for the service account sa-name@project-id.iam.gserviceaccount.com becomes sa-name@project-id.iam.
    sql_username                    = google_sql_user.service_account.name
    flask_secret_key                = random_password.flask_secret_key.result
    squarespace_api_key             = var.squarespace_api_key
    oauth_client_id                 = var.oauth_client_id
    oauth_client_secret             = var.oauth_client_secret
  })
}

resource "google_secret_manager_secret_iam_policy" "digital_membership" {
  project     = google_secret_manager_secret.digital_membership.project
  secret_id   = google_secret_manager_secret.digital_membership.id
  policy_data = data.google_iam_policy.secrets_access.policy_data
}

data "google_iam_policy" "secrets_access" {
  binding {
    role = "roles/secretmanager.secretAccessor"
    members = [
      # "serviceAccount:567739286055-compute@developer.gserviceaccount.com",
      "serviceAccount:${google_service_account.digital_membership.email}",
    ]
  }
}

resource "google_secret_manager_secret_iam_policy" "apple_private_key" {
  project     = google_secret_manager_secret.digital_membership.project
  secret_id   = "projects/${google_project.digital_membership.number}/secrets/${var.apple_pass_private_key_secret_name}/versions/latest"
  policy_data = data.google_iam_policy.secrets_access.policy_data
}

# resource "google_project_iam_member" "digital_membership_datastore_viewer" {
#   project = google_project.digital_membership.id
#   role    = "roles/datastore.viewer"
#   member  = "serviceAccount:${google_service_account.digital_membership.email}"
# }
