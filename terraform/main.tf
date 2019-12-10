provider "scaleway" {
  access_key = var.scw_access_key
  secret_key = var.scw_secret_key
  organization_id = var.scw_organization_id
    zone       = "fr-par-1"
  region     = "fr-par"
}


resource "scaleway_instance_ip" "server_ip" {
  server_id = "${scaleway_instance_server.web.id}"
  zone = "fr-par-1"
}

resource "scaleway_instance_security_group" "www" {
  inbound_default_policy = "drop"
  outbound_default_policy = "accept"
  name = "www"

  inbound_rule {
    action = "accept"
    port = "22"
    ip = var.source_ip
  }

  inbound_rule {
    action = "accept"
    port = "80"
  }

  inbound_rule {
    action = "accept"
    port = "443"
  }
}

data "scaleway_image" "ubuntu" {
  architecture = "x86_64"
  name         = "Ubuntu Bionic"
  most_recent = true
}

resource "scaleway_instance_server" "web" {
  type = "DEV1-S"
  image = "${data.scaleway_image.ubuntu.id}"
  name = "trinity"
  tags = [ "web", "nginx" ]
  #cloud_init = file("cloud_init.sh")

  security_group_id= "${scaleway_instance_security_group.www.id}"

  #provisioner "local-exec" {
  #  command = "apt-get update && apt-get upgrade"
  #}
}

