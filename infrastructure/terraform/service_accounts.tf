// Create service accounts
resource "yandex_iam_service_account" "sa" {
  for_each = var.service_accounts
  description = "Account for ${each.key}"
  name = each.key
}

 //Set roles for s3 service account
resource "yandex_resourcemanager_folder_iam_member" "s3_storage_editor_role" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa["s3"].id}"
}

 //Set roles for k8s service account
resource "yandex_resourcemanager_folder_iam_binding" "k8s_editor_role" {
  folder_id = var.folder_id
  role      = "editor"
  members    = ["serviceAccount:${yandex_iam_service_account.sa["k8s"].id}"]
}

 //Set roles for image puller service account
resource "yandex_resourcemanager_folder_iam_binding" "docker_image_puller_role" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  members   = ["serviceAccount:${yandex_iam_service_account.sa["docker"].id}"]
}

//Set static key for s3 service account
resource "yandex_iam_service_account_static_access_key" "s3_key" {
  service_account_id = yandex_iam_service_account.sa["s3"].id
  description        = "static key to access key for object storage"
}
