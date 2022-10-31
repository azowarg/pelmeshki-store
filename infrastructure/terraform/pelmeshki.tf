terraform {
  required_version = ">=0.13"
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  // Store tfstate in s3 bucket in yandex_cloud
  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "terraform-state-pelmeshki-bucket"
    region                      = "ru-central1-a"
    key                         = "terraform.tfstate"
    shared_credentials_file     = "./creds"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  token     = var.IAM_token
  zone      = var.zone
}

// Deploy s3 bucket for something
resource "yandex_storage_bucket" "pelmeski_s3_bucket" {
  access_key = yandex_iam_service_account_static_access_key.s3_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.s3_key.secret_key
  bucket     = "pelmeshki-storage"
  max_size   = 1048576
}

// Network for k8s needs
resource "yandex_vpc_network" "k8s-cluster" {
  name        = "k8s-network"
  description = "network for k8s cluster"
}

// Subnet for k8s cluster
resource "yandex_vpc_subnet" "k8s-cluster-subnet" {
  name           = "k8s-kluster-subnet"
  zone           = var.zone
  description    = "subnet for k8s"
  v4_cidr_blocks = ["10.100.96.0/20"]
  network_id     = yandex_vpc_network.k8s-cluster.id
}

// K8s cluster for our store
resource "yandex_kubernetes_cluster" "pelmeshki_k8s_cluster" {
 network_id = yandex_vpc_network.k8s-cluster.id
 master {
  public_ip = true
   zonal {
     zone      = yandex_vpc_subnet.k8s-cluster-subnet.zone
     subnet_id = yandex_vpc_subnet.k8s-cluster-subnet.id
   }
 }
 service_account_id      = yandex_iam_service_account.sa["k8s"].id
 node_service_account_id = yandex_iam_service_account.sa["k8s"].id
   depends_on = [
     yandex_resourcemanager_folder_iam_binding.k8s_editor_role,
     yandex_resourcemanager_folder_iam_binding.docker_image_puller_role
   ]
}

// Setup nodes in kluster
resource "yandex_kubernetes_node_group" "pelmeshki_k8s_nodes" {
  cluster_id = yandex_kubernetes_cluster.pelmeshki_k8s_cluster.id
  instance_template {
    platform_id = "standard-v1"
    network_interface {
      nat = true
      subnet_ids = ["${yandex_vpc_subnet.k8s-cluster-subnet.id}"]
    }
    resources {
      memory = 4
      cores = 2
    }
    boot_disk {
      type = "network-ssd"
      size = 64
    }
    container_runtime {
     type = "docker"
    }
  }
  scale_policy {
    fixed_scale {
      size = 1
    }
  }
  allocation_policy {
    location {
      zone = var.zone
    }
  }
}
