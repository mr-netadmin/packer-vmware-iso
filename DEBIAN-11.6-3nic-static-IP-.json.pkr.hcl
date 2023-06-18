//Packer image DEBIAN 11.6 preconfigure hostname, 3 nic, ip address
//nic 1 = vmnet1 = ens160, nic 2= vmnet2 = ens192, nic 3 = VMnet3 = ens224
//nat on VMnet8 (ens256) for installation http preceed
//nic 1 = VMnet1(ens160) ON debian ip = 172.16.5.1
//nic 2 = VMnet2(ens192) ON debian ip = 10.0.0.1
//nic 3 = VMnet3(ens224) ON debian ip = 192.168.1.1
//PC HOST "VMware Network Adapter VMnet1" static ip = 172.16.5.5
//iso location C://ISO
//iMAGE location  c:\VM\DEBIAN
//OVA location  c:\VM\OVA\DEBIAN.ova
//preceed file  c:\VM\http\preceed.cfg

variable "boot_wait" {
  type    = string
  default = "5s"
}

variable "iso_checksum" {
  type    = string
  default = "SHA256:55f6f49b32d3797621297a9481a6cc3e21b3142f57d8e1279412ff5a267868d8"
}

variable "iso_url" {
  type    = string
  default = "file:///C://ISO//debian-11.6.0-amd64-DVD-1.iso"
}

variable "numvcpus" {
  type    = string
  default = "1"
}

variable "ssh_password" {
  type    = string
  default = "D3bi4n"
}

variable "ssh_host" {
  type    = string
  default = "172.16.5.1"
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "vm-disk-size" {
  type    = string
  default = "10960"
}

variable "vm-mem-size" {
  type    = string
  default = "1024"
}

variable "vm_name" {
  type    = string
  default = "DEBIAN"
}

source "vmware-iso" "DEBIAN" {
  cpus             = "${var.numvcpus}"
  memory           = "${var.vm-mem-size}"
  boot_command     = [
        "<esc><wait>",
        "install <wait>",
        "debian-installer=en_US.UTF-8 <wait>",
        "auto <wait>",
        "locale=en_US.UTF-8 <wait>",
        "kbd-chooser/method=us <wait>",
        "keyboard-configuration/xkb-keymap=us <wait>",
        "netcfg/choose_interface=ens256 <wait>",
        "netcfg/get_hostname=DEBIAN <wait>",
        "netcfg/get_domain=DEBIAN.org <wait>",
        "netcfg/hostname=DEBIAN <wait>",
        "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preceed.cfg<enter>",               
  ]
  disk_size        = "${var.vm-disk-size}"
  disk_type_id     = "0"
  guest_os_type    = "debian11-64"
  headless         = false
  http_directory   = "http"
  http_port_min    = "8000"
  http_port_max    = "8000"
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${var.iso_url}"
  shutdown_command = "echo 'user'|sudo -S shutdown -P now"
  ssh_password     = "D3bi4n"
  ssh_port         = 22
  ssh_host         = "${var.ssh_host}"
  ssh_timeout      = "30h"
  ssh_username     = "root"
  vm_name          = "${var.vm_name}"
  version           = "20"
  output_directory  = "C:/VM/${var.vm_name}"

    vmx_data = {
    "ethernet0.connectionType" = "custom"
    "ethernet0.addressType" = "generated"
    "ethernet0.virtualDev" = "vmxnet3"
    "ethernet0.present" = "TRUE"
    "ethernet0.displayName" = "VMnet1"
    "ethernet0.vnet" = "VMnet1"
    "ethernet1.connectionType" = "custom"
    "ethernet1.addressType" = "generated"
    "ethernet1.virtualDev" = "vmxnet3"
    "ethernet1.present" = "TRUE"
    "ethernet1.displayName" = "VMnet2"
    "ethernet1.vnet" = "VMnet2" 
    "ethernet2.connectionType" = "custom"
    "ethernet2.addressType" = "generated"
    "ethernet2.virtualDev" = "vmxnet3"
    "ethernet2.present" = "TRUE"
    "ethernet2.displayName" = "VMnet3"
    "ethernet2.vnet" = "VMnet3"
    "ethernet3.connectionType" = "nat"
    "ethernet3.addressType" = "generated"
    "ethernet3.virtualDev" = "vmxnet3"
    "ethernet3.present" = "TRUE"
    "ethernet3.displayName" = "VMnet8"
    "ethernet3.vnet" = "VMnet8"         
      }

  vmx_data_post = {
  "cpuid.coresPerSocket"   = "1"
  "cleanShutdown" = "TRUE"
    "ethernet0.connectionType" = "custom"
    "ethernet0.addressType" = "generated"
    "ethernet0.virtualDev" = "vmxnet3"
    "ethernet0.present" = "TRUE"
    "ethernet0.displayName" = "VMnet1"
    "ethernet0.vnet" = "VMnet1"
    "ethernet1.connectionType" = "custom"
    "ethernet1.addressType" = "generated"
    "ethernet1.virtualDev" = "vmxnet3"
    "ethernet1.present" = "TRUE"
    "ethernet1.displayName" = "VMnet2"
    "ethernet1.vnet" = "VMnet2" 
    "ethernet2.connectionType" = "custom"
    "ethernet2.addressType" = "generated"
    "ethernet2.virtualDev" = "vmxnet3"
    "ethernet2.present" = "TRUE"
    "ethernet2.displayName" = "VMnet3"
    "ethernet2.vnet" = "VMnet3"       
  }
}

build {
  sources = ["source.vmware-iso.DEBIAN"]

  post-processor "shell-local" {
  scripts          = [".http/DEBIAN_OVA.cmd"]
}

}
