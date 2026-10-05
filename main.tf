terraform {
  required_providers {
    docker = {
        source = "kreuzwerker/docker"
        version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "portainer" {
 name  = "portainer/portainer-ce:latest"
 keep_locally = false 
}

resource "docker_volume" "portainer_data" {
  name = "portainer_data"
}




resource "docker_container" "portainer" {
  name    = "terraform-portainer"
  image   = docker_image.portainer.image_id
  restart = "unless-stopped"
  
   ports {
    internal = 9000
    external = 9000
  }

  ports {
    internal = 9443
    external = 9443
  }
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  
  volumes {
    volume_name    = docker_volume.portainer_data.name
    container_path = "/data"
  }

  
}