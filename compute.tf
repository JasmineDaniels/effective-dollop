provider "oci" {
    tenancy_ocid = var.tenancy_ocid
    user_ocid = var.user_ocid
    fingerprint = var.fingerprint
    region = var.region
}

variable "availability_domain" {
    default = "hsRu:US-ASHBURN-AD-1"
}

resource "oci_core_instance" "compute_instance1" {
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
        subnet_id = resource.oci_core_subnet.subnet_2.id
        display_name = "Primaryvnic"
        hostname_label = "complex-env-vm01"
    }

    metadata = {
        ssh_authorized_keys = var.pub_key
        user_data = "${base64encode(file("./init_script1.sh"))}"
    }

    preserve_boot_volume = false
}

resource "oci_core_instance" "compute_instance2" {
    # Required
    availability_domain = "hsRu:US-ASHBURN-AD-3"
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
        subnet_id = resource.oci_core_subnet.subnet_2.id
        display_name = "Primaryvnic"
        hostname_label = "complex-env-vm02"
    }

    metadata = {
        ssh_authorized_keys = var.pub_key
        user_data = "${base64encode(file("./init_script1.sh"))}"
    }

    preserve_boot_volume = false
}

# Output the result
output "show-vm2-shape" {
    value = resource.oci_core_instance.compute_instance2.shape
}