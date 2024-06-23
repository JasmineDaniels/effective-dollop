provider "oci" {
    tenancy_ocid = var.tenancy_ocid
    user_ocid = var.user_ocid
    fingerprint = var.fingerprint
    private_key_path = var.private_key_path
    region = var.region
    private_key_password = var.private_key_password
}

variable "availability_domain" {
    default = "hsRu:US-ASHBURN-AD-1"
}

resource "oci_core_instance" "test-instance" {
    # Required
    availability_domain = var.availability_domain
    compartment_id = var.compartment_id
    shape = "VM.Standard.A1.Flex"
    display_name = "my-terraform-vm1"
    shape_config {
        memory_in_gbs = 6
        ocpus = 1
    }

    source_details {
        source_id = "ocid1.image.oc1.iad.aaaaaaaamo3amvibu2izgrng5zs4u34yw5y2g2v3v5l4fxvbeezepcsren7q"
        source_type = "image"
    }

    create_vnic_details {
        assign_public_ip = true
        subnet_id = "ocid1.subnet.oc1.iad.aaaaaaaagr22ow6lmuhhstmus6rmfhmtooc7ltqintqsuz4wsxiras32b7ra"
        display_name = "Primaryvnic"
        hostname_label = "complex-env-vm01"
    }
    preserve_boot_volume = false
}

resource "oci_core_instance" "tester-instance" {
    # Required
    availability_domain = var.availability_domain
    compartment_id = var.compartment_id
    display_name = "my-terraform-vm2"
    shape = "VM.Standard.A1.Flex"
    shape_config {
        memory_in_gbs = 6
        ocpus = 1
    }

    source_details {
        source_id = "ocid1.image.oc1.iad.aaaaaaaamo3amvibu2izgrng5zs4u34yw5y2g2v3v5l4fxvbeezepcsren7q"
        source_type = "image"
    }

    create_vnic_details {
        assign_public_ip = true
        subnet_id = "ocid1.subnet.oc1.iad.aaaaaaaagr22ow6lmuhhstmus6rmfhmtooc7ltqintqsuz4wsxiras32b7ra"
        display_name = "Primaryvnic"
        hostname_label = "complex-env-vm01"
    }
    preserve_boot_volume = false
}

# Output the result
output "show-vm2-shape" {
    value = resource.oci_core_instance[1].tester-instance.shape
}