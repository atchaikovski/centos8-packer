locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "vsphere-iso" "centos8gen" {
  CPUs                 = "${var.vm-cpu-num}"
  RAM                  = "${var.vm-mem-size}"
  RAM_reserve_all      = false
  boot_command         = ["<esc><wait>", " linux ks=hd:fd0:/ks.cfg<enter>"]
  boot_order           = "disk,cdrom,floppy"
  boot_wait            = "10s"
  cluster              = "${var.vsphere-cluster}"
  convert_to_template  = true
  datacenter           = "${var.vsphere-datacenter}"
  datastore            = "${var.vsphere-datastore}"
  disk_controller_type = ["pvscsi"]
  floppy_files         = ["ks.cfg"]
  guest_os_type        = "centos-64"
  insecure_connection  = "true"
  iso_paths            = ["${var.iso_url}"]
  network_adapters {
    network      = "${var.vsphere-network}"
    network_card = "vmxnet3"
  }
  notes                = "Built with Packer, template for Centos7"
  password             = "${var.vsphere-password}"
  ssh_certificate_file = "~/.ssh/id_rsa"
  ssh_password         = "P@sw0rd1"
  ssh_timeout          = "6000s"
  ssh_username         = "root"
  ssh_wait_timeout     = "6000s"
  storage {
    disk_size             = "${var.vm-disk-size}"
    disk_thin_provisioned = true
  }
  username       = "${var.vsphere-user}"
  vcenter_server = "${var.vsphere-server}"
  vm_name        = "centos8-${ local.timestamp }"   
  #vm_name        = "${var.vm-name}"
}

build {
  sources = ["source.vsphere-iso.centos8gen"]

  provisioner "shell" {
    scripts = [
      "scripts/packages.sh",
      "scripts/cleanup.sh"
    ]
  }
}
