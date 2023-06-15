
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
  default = "file:///C://ISO//17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
}

variable "iso_checksum" {
  type    = string
  default = "35258eca46d1cdaaa64a577ab5765b15450c68ad2336af4e6caaf4fc758c5088"
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
  floppy_files      = ["config/W2K19/autounattend.xml"]
  guest_os_type     = "windows2019srv-64"
  headless          = false
  iso_checksum      = "${var.iso_checksum}"
  iso_url           = "${var.iso}"
  memory            = "${var.memsize}"
  output_directory  = "WIN2K19"
  shutdown_command  = "shutdown /s /t 5 /f /d p:4:1 /c \"user Shutdown\""
  shutdown_timeout  = "30m"
  skip_compaction   = false
  version           = "19"
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
  }
  winrm_insecure = true
  winrm_password = "${var.winrm_password}"
  winrm_timeout  = "2h"
  winrm_use_ssl  = false
  winrm_username = "${var.winrm_username}"
}

build {
  sources = ["source.vmware-iso.W2K19"]

  provisioner powershell {
    elevated_password = "${var.winrm_password}"
    elevated_user = "${var.winrm_username}"
    scripts = [
      "./config/install-vmware-tools.ps1",
    ]
  }


}
