variable "IAM_token" {
  description = "Enter IAM token to access Yandex.Cloud"
}
variable "pic_path" {
  default = "/home/student/pelmeni/pictures"
}

variable "cloud_id" {
  default = "b1gincs6q48uo3proe1f"
}

variable "folder_id" {
  default = "b1gb8ncd1ns7fcq4113q"
}

variable "zone" {
  default = "ru-central1-a"
}

variable "image" {
  default = "fd80qm01ah03dkqb14lc"
}

variable "subnet" {
  default = "e9bv2h8n8s1083clp85e"
}

variable "service_accounts" {
  description = "List of service accounts"
  type        = map(string)
  default = {
    "s3"     = "s3-service-acc"
    "k8s"    = "k8s-service-acc"
    "docker" = "image-puller-service-acc"
  }
}
