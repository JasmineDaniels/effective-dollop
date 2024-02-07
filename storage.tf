variable "db_size" {
    default = 50
}

resource "oci_core_volume" "test_block_vol_paravirtualized" {
    availability_domain = "hsRu:US-ASHBURN-AD-1"
    compartment_id = var.compartment_id
    display_name = "TestBlockVirtualized"
    size_in_gbs = var.db_size
}