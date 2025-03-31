variable "block_size" {
    default = 50
}

resource "oci_core_volume" "test_block_vol_paravirtualized" {
    availability_domain = var.availability_domain
    compartment_id = var.compartment_id
    display_name = "TestBlockVirtualized"
    size_in_gbs = var.block_size
}