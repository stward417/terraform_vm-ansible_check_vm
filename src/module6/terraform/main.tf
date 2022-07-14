terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = "..."
  cloud_id  = "..."
  folder_id = "..."
  zone      = "ru-central1-a"
}



resource "yandex_iam_service_account" "admin" {
  name        = "admin"
  description = "service account to manage IG"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = "..."
  role      = "editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.admin.id}",
  ]
  depends_on = [
    yandex_iam_service_account.admin,
  ]
}



resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}




resource "yandex_compute_instance" "vm1" {
  name        = "vm1"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "..."
      size = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./user_data/user_data.txt")}"
  }
}



resource "yandex_compute_instance" "vm2" {
  name        = "vm2"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "..."
      size = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./user_data/user_data.txt")}"
  }
}


resource "yandex_compute_instance" "vm3" {
  name        = "vm3"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "..."
      size = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./user_data/user_data.txt")}"
  }
}






output "internal_ip_address_vm1" {
  value = yandex_compute_instance.vm1.network_interface.0.ip_address
}

output "internal_ip_address_vm2" {
  value = yandex_compute_instance.vm2.network_interface.0.ip_address
}

output "internal_ip_address_vm3" {
  value = yandex_compute_instance.vm3.network_interface.0.ip_address
}



output "external_ip_address_vm1" {
  value = yandex_compute_instance.vm1.network_interface.0.nat_ip_address
}

output "external_ip_address_vm2" {
  value = yandex_compute_instance.vm2.network_interface.0.nat_ip_address
}

output "external_ip_address_vm3" {
  value = yandex_compute_instance.vm3.network_interface.0.nat_ip_address
}
