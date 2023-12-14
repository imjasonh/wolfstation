/*
Copyright 2023 Chainguard, Inc.
SPDX-License-Identifier: Apache-2.0
*/

variable "project" {
  description = "The project in which to create the cluster."
}

variable "region" {
  description = "The region in which to create the cluster."
  default     = "us-east4"
}

variable "name" {
  description = "The name of resources created in the project."
  default     = "work"
}

variable "machine_type" {
  description = "The machine type to use for the cluster."
  default     = "e2-standard-4"
}

variable "disk_gb" {
  description = "The size of the disk to use for the cluster."
  default     = 35
}

// Number of seconds to wait before automatically stopping a workstation after it last received user traffic.
variable "idle_timeout" {
  description = "The idle timeout for the cluster."
  default     = "${10 * 60}s" // 10 minutes
}

// Number of seconds that a workstation can run until it is automatically shut down.
// We recommend that workstations be shut down daily to reduce costs and so that security updates can be applied upon restart.
variable "running_timeout" {
  description = "The running timeout for the cluster."
  default     = "${12 * 60 * 60}s" // 12 hours
}

variable "extra_packages" {
  description = "Additional packages to install."
  type        = list(string)
  default     = []
}

variable "extra_roles" {
  description = "The additional roles to grant to the service account."
  type        = list(string)
  default     = []
}
