# © Broadcom. All Rights Reserved.
# The term “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
# SPDX-License-Identifier: BSD-2-Clause

/*
    DESCRIPTION:
    Microsoft Windows Server 2025 input variables.
    Packer Plugin for VMware vSphere: 'vsphere-iso' builder.
*/

//  BLOCK: variable
//  Defines the input variables.


// vSphere Settings


// Installer Settings

variable "vm_inst_os_language" {
  type        = string
  description = "The installation operating system lanugage."
  default     = "en-US"
}

variable "vm_inst_os_keyboard" {
  type        = string
  description = "The installation operating system keyboard input."
  default     = "en-US"
}

variable "vm_inst_os_eval" {
  type        = bool
  description = "Build using the operating system evaluation"
  default     = true
}

variable "vm_inst_os_image_standard_core" {
  type        = string
  description = "The installation operating system image input for Microsoft Windows Standard Core."
  default     = "Windows Server 2025 SERVERSTANDARDCORE"
}

variable "vm_inst_os_image_standard_desktop" {
  type        = string
  description = "The installation operating system image input for Microsoft Windows Standard."
  default     = "Windows Server 2025 SERVERSTANDARD"
}

variable "vm_inst_os_key_standard" {
  type        = string
  description = "The installation operating system key input for Microsoft Windows Standard edition."
}

variable "vm_inst_os_image_datacenter_core" {
  type        = string
  description = "The installation operating system image input for Microsoft Windows Datacenter Core."
  default     = "Windows Server 2025 SERVERDATACENTERCORE"
}

variable "vm_inst_os_image_datacenter_desktop" {
  type        = string
  description = "The installation operating system image input for Microsoft Windows Datacenter."
  default     = "Windows Server 2025 SERVERDATACENTER"
}

variable "vm_inst_os_key_datacenter" {
  type        = string
  description = "The installation operating system key input for Microsoft Windows Datacenter edition."
}

// Virtual Machine Settings

variable "vm_guest_os_language" {
  type        = string
  description = "The guest operating system lanugage."
  default     = "en-US"
}

variable "vm_guest_os_keyboard" {
  type        = string
  description = "The guest operating system keyboard input."
  default     = "en-US"
}

variable "vm_guest_os_timezone" {
  type        = string
  description = "The guest operating system timezone."
  default     = "UTC"
}

variable "vm_guest_os_family" {
  type        = string
  description = "The guest operating system family. Used for naming and VMware Tools."
  default     = "windows"
}

variable "vm_guest_os_name" {
  type        = string
  description = "The guest operating system name. Used for naming."
  default     = "server"
}

variable "vm_guest_os_version" {
  type        = string
  description = "The guest operating system version. Used for naming."
  default     = "2025"
}

variable "vm_guest_os_edition_standard" {
  type        = string
  description = "The guest operating system edition. Used for naming."
  default     = "standard"
}

variable "vm_guest_os_edition_datacenter" {
  type        = string
  description = "The guest operating system edition. Used for naming."
  default     = "datacenter"
}

variable "vm_guest_os_experience_core" {
  type        = string
  description = "The guest operating system minimal experience. Used for naming."
  default     = "core"
}

variable "vm_guest_os_experience_desktop" {
  type        = string
  description = "The guest operating system desktop experience. Used for naming."
  default     = "dexp"
}

variable "common_remove_cdrom" {
  type        = bool
  description = "Remove the virtual CD-ROM(s)."
  default     = true
}

// Template and Content Library Settings

variable "common_template_conversion" {
  type        = bool
  description = "Convert the virtual machine to template. Must be 'false' for content library."
  default     = false
}

variable "common_content_library_enabled" {
  type        = bool
  description = "Import the virtual machine into the vSphere content library."
  default     = true
}

variable "common_content_library" {
  type        = string
  description = "The name of the target vSphere content library, if enabled."
  default     = null
}

variable "common_content_library_ovf" {
  type        = bool
  description = "Export to content library as an OVF template."
  default     = true
}

variable "common_content_library_destroy" {
  type        = bool
  description = "Delete the virtual machine after exporting to the content library."
  default     = true
}

variable "common_content_library_skip_export" {
  type        = bool
  description = "Skip exporting the virtual machine to the content library. Option allows for testing/debugging without saving the machine image."
  default     = false
}

// OVF Export Settings

variable "common_ovf_export_enabled" {
  type        = bool
  description = "Enable OVF artifact export."
  default     = false
}

variable "common_ovf_export_overwrite" {
  type        = bool
  description = "Overwrite existing OVF artifact."
  default     = true
}

// Removable Media Settings

variable "common_iso_content_library_enabled" {
  type        = bool
  description = "Import the guest operating system ISO into the vSphere content library."
  default     = false
}

variable "common_iso_datastore" {
  type        = string
  description = "The name of the target vSphere datastore for the guest operating system ISO."
}

variable "iso_datastore_path" {
  type        = string
  description = "The path on the source vSphere datastore for the guest operating system ISO."
}

variable "iso_content_library_item" {
  type        = string
  description = "The vSphere content library item name for the guest operating system ISO."
}

// Boot Settings

variable "common_data_source" {
  type        = string
  description = "The provisioning data source. One of `http` or `disk`."
}

variable "common_http_ip" {
  type        = string
  description = "Define an IP address on the host to use for the HTTP server."
  default     = null
}

variable "common_http_port_min" {
  type        = number
  description = "The start of the HTTP port range."
}

variable "common_http_port_max" {
  type        = number
  description = "The end of the HTTP port range."
}

variable "vm_shutdown_command" {
  type        = string
  description = "Command(s) for guest operating system shutdown."
  default     = "shutdown /s /t 10 /f /d p:4:1 /c \"Shutdown by Packer\""
}

variable "common_shutdown_timeout" {
  type        = string
  description = "Time to wait for guest operating system shutdown."
}

// Communicator Settings and Credentials

variable "build_password_encrypted" {
  type        = string
  description = "The SHA-512 encrypted password to login to the guest operating system."
  sensitive   = true
  default     = ""
}

variable "build_key" {
  type        = string
  description = "The public key to login to the guest operating system."
  sensitive   = true
  default     = ""
}

// Ansible Credentials

variable "ansible_username" {
  type        = string
  description = "The username for Ansible to login to the guest operating system."
  sensitive   = true
}

variable "ansible_key" {
  type        = string
  description = "The public key for Ansible to login to the guest operating system."
  sensitive   = true
}

// Provisioner Settings

variable "scripts" {
  type        = list(string)
  description = "A list of scripts and their relative paths to transfer and run."
  default     = []
}

variable "inline" {
  type        = list(string)
  description = "A list of commands to run."
  default     = []
}

// HCP Packer Settings

variable "common_hcp_packer_registry_enabled" {
  type        = bool
  description = "Enable the HCP Packer registry."
  default     = false
}