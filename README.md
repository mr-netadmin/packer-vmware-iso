# Packer-VMWare-iso Windows 10, Windows 2019 for VMWare Workstation + Static IP + Export OVA

Installation Windows Image and VMWare Tools

C:\ISO > ISO File

config/WIN10/bios/Autounattend.xml > floppy file  

run:

 .\packer.exe init .\WIN10-bios.json.pkr.hcl

  .\packer.exe validate .\WIN10-bios.json.pkr.hcl
 
 .\packer.exe build .\WIN10-bios.json.pkr.hcl
