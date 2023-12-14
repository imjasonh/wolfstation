/*
Copyright 2023 Chainguard, Inc.
SPDX-License-Identifier: Apache-2.0
*/

terraform {
  required_providers {
    apko        = { source = "chainguard-dev/apko" }
    cosign      = { source = "chainguard-dev/cosign" }
    oci         = { source = "chainguard-dev/oci" }
    google      = { source = "hashicorp/google" }
    google-beta = { source = "hashicorp/google-beta" }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

provider "google-beta" {
  project = var.project
  region  = var.region
}

provider "apko" {
  extra_repositories = ["https://packages.wolfi.dev/os"]
  extra_keyring      = ["https://packages.wolfi.dev/os/wolfi-signing.rsa.pub"]
  default_archs      = ["x86_64"]
  extra_packages     = ["wolfi-baselayout"]
}

resource "google_artifact_registry_repository" "repo" {
  format        = "DOCKER"
  repository_id = var.name
  location      = var.region
}

module "image" {
  source = "./image"

  target_repository = "${var.region}-docker.pkg.dev/${var.project}/${google_artifact_registry_repository.repo.name}/work"
  extra_packages    = var.extra_packages
}

module "workstation" {
  source = "./workstation"

  image           = module.image.image_ref
  project         = var.project
  region          = var.region
  name            = var.name
  machine_type    = var.machine_type
  disk_gb         = var.disk_gb
  idle_timeout    = var.idle_timeout
  running_timeout = var.running_timeout
}

output "ssh_command" { value = module.workstation.ssh_command }
output "stop_command" { value = module.workstation.stop_command }
