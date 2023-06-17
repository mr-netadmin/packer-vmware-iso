//Packer for win2019 + install vmtools with static ip 172.16.1.1 + export OVA
//On pc need to set static ip 172.16.1.x on VMnet1
//image locate C:\VM\W2K19\
//image export to C:\VM\OVA\WIN2K.OVA
//ISO disc on C:\VM\ISO
//Autoanswer file on folder config/W2K19/

variable "boot_wait" {
  type    = string
  default = "5s"
}

variable "disk_size" {
  type    = string
  default = "40960"
}

variable "iso" {
  type    = string
  default = "file:///C://VM/ISO//17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
}

variable "iso_checksum" {
  type    = string
  default = "6dae072e7f78f4ccab74a45341de0d6e2d45c39be25f1f5920a2ab4f51d7bcbb"
}

variable "memsize" {
  type    = string
  default = "4096"
}

variable "numvcpus" {
  type    = string
  default = "2"
}

variable "vm_name" {
  type    = string
  default = "WIN2K19"
}

variable "vmtools" {
  type    = string
  default = "C:\\Program Files (x86)\\VMware\\VMware Workstation\\windows.iso"
}

variable "winrm_password" {
  type    = string
  default = "W1N@2K19"
}

variable "winrm_username" {
  type    = string
  default = "Administrator"
}

source "vmware-iso" "W2K19" {
  boot_wait         = "${var.boot_wait}"
  communicator      = "winrm"
  cpus              = "${var.numvcpus}"
  disk_adapter_type = "nvme"
  disk_size         = "${var.disk_size}"
  disk_type_id      = "0"
  floppy_files      = ["config/W2K19/"]
  network_adapter_type = "e1000e"
  network           = "nat" 
  guest_os_type     = "windows2019srv-64"
  headless          = false
  iso_checksum      = "${var.iso_checksum}"
  iso_url           = "${var.iso}"
  memory            = "${var.memsize}"
  output_directory  = "W2K19"
  shutdown_command  = "shutdown /s /t 5 /f /d p:4:1 /c \"user Shutdown\""
  shutdown_timeout  = "30m"
  skip_compaction   = false
  version           = "20"
  vm_name           = "${var.vm_name}"
  vmx_data = {
    "bios.bootOrder"         = "hdd,cdrom"
    "bios.hddOrder"          = "sata0:0"
    "sata0:0.present"        = "TRUE"
    "sata0:0.startConnected" = "TRUE"
    "sata1.present"          = "TRUE"
    "sata1:0.devicetype"     = "cdrom-image"
    "sata1:0.filename"       = "${var.vmtools}"
    "sata1:0.present"        = "TRUE"
    "sata1:0.startConnected" = "TRUE"
    "ethernet0.connectionType" = "custom"
    "ethernet0.addressType" = "generated"
    "ethernet0.virtualDev" = "e1000e"
    "ethernet0.present" = "TRUE"
    "ethernet0.displayName" = "VMnet1"
    "ethernet0.vnet" = "VMnet1"
      }

  vmx_data_post = {
  "bios.hddOrder"          = "nvme"
  "cpuid.coresPerSocket"   = "1"
  "cleanShutdown" = "TRUE"
  "sata1.present"          = "FALSE"
  "sata1:0.present"        = "FALSE"
  "sata1:0.startConnected" = "FALSE"
    "ethernet0.connectionType" = "custom"
    "ethernet0.addressType" = "generated"
    "ethernet0.virtualDev" = "e1000e"
    "ethernet0.present" = "TRUE"
    "ethernet0.displayName" = "VMnet1"
    "ethernet0.vnet" = "VMnet1"
  }

  winrm_insecure = true
  winrm_password = "${var.winrm_password}"
  winrm_timeout  = "2h"
  winrm_host  = "172.16.1.1"
  winrm_use_ssl  = false
  winrm_username = "${var.winrm_username}"
}

build {
  sources = ["source.vmware-iso.W2K19"]

  provisioner powershell {
    elevated_password = "${var.winrm_password}"
    elevated_user = "${var.winrm_username}"
    scripts = ["./config/install-vmware-tools.ps1",]
  }

  post-processor "shell-local" {
  scripts          = ["./config/W2K19_OVA.cmd"]
}

}
