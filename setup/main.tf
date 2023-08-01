/*
Copyright 2023 Chainguard, Inc.
SPDX-License-Identifier: Apache-2.0
*/

resource "google_service_account" "gh" {
  project = var.project

  account_id   = var.name
  display_name = "Wolfstation SA (${var.name})"
}

module "gh_oidc" {
  source = "registry.terraform.io/terraform-google-modules/github-actions-runners/google//modules/gh-oidc"

  project_id  = var.project
  pool_id     = var.name
  provider_id = var.name

  sa_mapping = {
    (google_service_account.gh.account_id) = {
      sa_name   = google_service_account.gh.name
      attribute = "attribute.repository/${var.github_org}/${var.github_repo}"
    }
  }
}

module "project_iam_bindings" {
  source = "registry.terraform.io/terraform-google-modules/iam/google//modules/projects_iam"

  projects = [var.project]
  mode     = "authoritative"

  bindings = {
    "roles/artifactregistry.writer" = ["serviceAccount:${google_service_account.gh.email}"]
    "roles/workstations.admin"      = ["serviceAccount:${google_service_account.gh.email}"]
  }
}

output "github_workflow_step" {
  value = <<EOF

    # Add this to your GitHub Actions workflow file.
    - uses: 'google-github-actions/auth@v1'
      with:
        workload_identity_provider: ${module.gh_oidc.provider_name}
        service_account: ${google_service_account.gh.email}

EOF
}
