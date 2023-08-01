# One-time setup

This directory contains Terraform config for one-time setup to allow
your Wolfstation to automatically build and deploy new workstation images
using GitHub Actions.

Once you've done this once, you shouldn't need to do it again unless you
change the GitHub repository used to build and update the workstation config.

To set up access:

```shell
TF_VAR_project=$(gcloud config get-value project)
TF_VAR_github_org=[my-github-org]
TF_VAR_github_repo=[my-github-repo]
terraform apply
```

This will create a GCP service account with permissions to build and deploy,
and set up Workload Identity Federation with the GitHub repo's Actions identity.

In the output you should see a GitHub Actions step to use to authorize the GitHub
Actions identity to access the GCP service account. Copy and paste this output into
your copy of [`.github/workflows/release.yaml`](../../.github/workflows/release.yaml).

You can also uncomment the `schedule:` section to automatically run this workflow on
a nightly basis.
