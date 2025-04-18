resource "google_storage_bucket" "bucket" {
  name     = var.bucket_name
  location = var.location
  versioning {
    enabled = var.versioning_enabled
  }
  uniform_bucket_level_access = var.uniform_access
  force_destroy               = var.force_destroy
}

locals {
  file_list        = fileset("${path.module}/files", "*")
  upload_files_map = { for file in local.file_list : file => "${path.module}/files/${file}" }
}

resource "google_storage_bucket_object" "upload_files" {
  for_each = local.upload_files_map

  name   = each.key
  source = each.value
  bucket = google_storage_bucket.bucket.name
}
