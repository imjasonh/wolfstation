/*
Copyright 2023 Chainguard, Inc.
SPDX-License-Identifier: Apache-2.0
*/

output "ssh_command" {
  value = <<EOF
gcloud workstations start \
    --project=${var.project} \
    --region=${var.region} \
    --cluster=${var.name} \
    --config=${var.name} \
    ${var.name}

gcloud workstations ssh \
    --project=${var.project} \
    --region=${var.region} \
    --cluster=${var.name} \
    --config=${var.name} \
    ${var.name}
  EOF
}

output "stop_command" {
  value = <<EOF
gcloud workstations stop \
    --project=${var.project} \
    --region=${var.region} \
    --cluster=${var.name} \
    --config=${var.name} \
    ${var.name}
EOF
}
