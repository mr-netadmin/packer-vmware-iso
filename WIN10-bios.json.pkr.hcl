
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
  default = "file:///C://ISO//19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
}

variable "iso_checksum" {
  type    = string
  default = "ef7312733a9f5d7d51cfa04ac497671995674ca5e1058d5164d6028f0938d668"
}

variable "memsize" {
  type    = string
  default = "4096"
}

variable "numvcpus" {
  type    = string
  default = "2"
}

variable "remove_ethernet" {
  type    = string
  default = "true"
}

variable "vm_name" {
  type    = string
  default = "WIN10"
}

variable "vmtools" {
  type    = string
  default = "C:\\Program Files (x86)\\VMware\\VMware Workstation\\windows.iso"
}

variable "winrm_password" {
  type    = string
  default = "W1n@10"
}

variable "winrm_username" {
  type    = string
  default = "Administrator"
}
variable "vm_firmware" {
  type        = string
  description = "The virtual machine firmware. (e.g. 'efi-secure'. 'efi', or 'bios')"
  default     = "bios"
}

source "vmware-iso" "WIN10" {
  boot_wait         = "${var.boot_wait}"
  boot_command      = ["a<enter><wait>"]
  communicator      = "winrm"
  cpus              = "${var.numvcpus}"
  disk_adapter_type = "nvme"
  disk_size         = "${var.disk_size}"
  disk_type_id      = "0"
  network_adapter_type = "e1000e"
  network           = "NAT" 
  floppy_files      = ["config/WIN10/"]
  guest_os_type     = "windows9-64"
  headless          = false
  iso_checksum      = "${var.iso_checksum}"
  iso_url           = "${var.iso}"
  memory            = "${var.memsize}"
  output_directory  = "C:/VM/WIN10"
  shutdown_command  = "shutdown /s /t 5 /f /d p:4:1 /c \"user Shutdown\""
  shutdown_timeout  = "30m"
  skip_compaction   = false
  version           = "20"
  vm_name           = "${var.vm_name}"
  vmx_data = {
    "firmware" = "bios"
    "cpuid.coresPerSocket"   = "1"
    "bios.bootOrder"                        = "hdd,cdrom"
    "bios.hddOrder"                         = "sata0:0"
    "sata0:0.present"                       = "TRUE"
    "sata0:0.startConnected"                = "TRUE"
    "sata1.present"                         = "TRUE"
    "sata1:0.devicetype"                    = "cdrom-image"
    "sata1:0.filename"                      = "${var.vmtools}"
    "sata1:0.present"                       = "TRUE"
    "sata1:0.startConnected"                = "TRUE"
  }
  winrm_insecure = true
  winrm_password = "${var.winrm_password}"
  winrm_timeout  = "2h"
  winrm_use_ssl  = false
  winrm_username = "${var.winrm_username}"
}

build {
  sources = ["source.vmware-iso.WIN10"]

  provisioner powershell {
    elevated_password = "${var.winrm_password}"
    elevated_user = "${var.winrm_username}"
    scripts = [
      "./config/install-vmware-tools.ps1",
    ]
  }




}
