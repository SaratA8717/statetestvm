
# #Windows Server 2022 Data Center VM 
# Specs: "Standard_F64s_v2"	64cpu	128memory

module "AZEVAIOLPMMS001" {
  source                       = "app.terraform.io/simplifycloud/windowsvm/azure"
  version                      = "1.1.1"
  rg_name                      = module.resource-groups.eus2_rg_name
  location                     = module.resource-groups.eus2_rg_location
  static_ip                    = "10.230.5.11"
  subnet                       = module.subnets["snet_logrhythm_eus2"].subnet_id
  vm_name                      = "AZEVAIOLPMMS001"
  vm_sku                       = "Standard_D64ds_v5"
  windowsadminusername         = var.windowsadminusername
  windowsadminpassword         = var.windowsadminpassword
  license_type                 = "Windows_Server"
  os2022                       = true
  disk_encryption_set_id       = azurerm_disk_encryption_set.des_ce_logrhythm.id
  backups_enabled              = true
  backup_policy_id             = azurerm_backup_policy_vm.bup_vm_lr_standard_eus2.id
  recovery_services_vault_name = module.rsv_logrhtyhm.rsv_name
  data_disk_needed             = true
  data_disk_size_gb            = "5"
  temp_disk_needed             = true
  temp_disk_size_gb             = "5"
  tags                         = var.eus2_tags
  disable_caching_on_data_disk = true
}


###Data Disk # 2 L: Drive 500gb
resource "azurerm_managed_disk" "md_AZEVAIOLPMMS001_data03" {
  name                   = "md-AZEVAIOLPMMS001-data03"
  resource_group_name    = "rg-logrhythm-eus2"
  location               = "East US 2"
  storage_account_type   = "Premium_LRS"
  zone = 1
  disk_size_gb           = "100"
  create_option          = "Empty"
  disk_encryption_set_id = azurerm_disk_encryption_set.des_ce_logrhythm.id
}


#attatch data disk 2
resource "azurerm_virtual_machine_data_disk_attachment" "dda_AZEVAIOLPMMS001_data03" {
  managed_disk_id    = azurerm_managed_disk.md_AZEVAIOLPMMS001_data03.id
  virtual_machine_id = module.AZEVAIOLPMMS001.vm_id
  lun                = "40"
  create_option      = "Attach"
  caching            = "ReadWrite"
}


###Data Disk # 2 L: Drive 500gb
resource "azurerm_managed_disk" "md_AZEVAIOLPMMS001_data04" {
  name                   = "md-AZEVAIOLPMMS001-data04"
  resource_group_name    = "rg-logrhythm-eus2"
  location               = "East US 2"
  storage_account_type   = "Premium_LRS"
  zone = 1
  disk_size_gb           = "5"
  create_option          = "Empty"
  disk_encryption_set_id = azurerm_disk_encryption_set.des_ce_logrhythm.id
}


#attatch data disk 2
resource "azurerm_virtual_machine_data_disk_attachment" "dda_AZEVAIOLPMMS001_data04" {
  managed_disk_id    = azurerm_managed_disk.md_AZEVAIOLPMMS001_data04.id
  virtual_machine_id = module.AZEVAIOLPMMS001.vm_id
  lun                = "50"
  create_option      = "Attach"
  caching            = "ReadWrite"
}

