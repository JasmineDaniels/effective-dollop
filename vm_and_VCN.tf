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
    shape_config {
        memory_in_gbs = 6
        ocpus = 1
    }

    source_details {
        source_id = "ocid1.image.oc1.iad.aaaaaaaamo3amvibu2izgrng5zs4u34yw5y2g2v3v5l4fxvbeezepcsren7q"
        source_type = "image"
    }

    display_name = "my-terraform-vm"
    create_vnic_details {
        assign_public_ip = true
        subnet_id = "ocid1.subnet.oc1.iad.aaaaaaaagr22ow6lmuhhstmus6rmfhmtooc7ltqintqsuz4wsxiras32b7ra"
        display_name = "Primaryvnic"
        hostname_label = "complex-env-vm01"
    }
    preserve_boot_volume = false
}

resource "oci_core_vcn" "terraform_vcn" {
    cidr_block = "10.3.0.0/16"
    compartment_id = var.compartment_id
    display_name = "testVCN_terraform"
    dns_label = "testVCN1dns"
}

resource "oci_core_internet_gateway" "terraform_internet_gateway" {
    compartment_id = var.compartment_id
    display_name = "TerraformInternetGateway"
    vcn_id = oci_core_vcn.terraform_vcn.id
}

resource "oci_core_default_route_table" "default_route_table" {
    manage_default_resource_id = oci_core_vcn.terraform_vcn.default_route_table_id
    display_name = "TerrDefaultRouteTable"

    route_rules {
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
        network_entity_id = oci_core_internet_gateway.terraform_internet_gateway.id
    }
}



resource "oci_core_subnet" "test_subnet" {
    availability_domain = var.availability_domain
    #cidr_block = "10.1.20.0/24"
    cidr_block = "10.3.1.0/24"
    display_name = "TestSubnet-Private"
    dns_label = "testPrivate"
    security_list_ids = [oci_core_vcn.terraform_vcn.default_security_list_id]
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.terraform_vcn.id
    route_table_id = oci_core_vcn.terraform_vcn.default_route_table_id
    dhcp_options_id = oci_core_vcn.terraform_vcn.default_dhcp_options_id
}

resource "oci_core_subnet" "testing_subnet_two" {
    cidr_block = "10.3.0.0/24"
    display_name = "TestSubnet-Public"
    dns_label = "testPublic"
    security_list_ids = [oci_core_vcn.terraform_vcn.default_security_list_id]
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.terraform_vcn.id
    route_table_id = oci_core_vcn.terraform_vcn.default_route_table_id
    dhcp_options_id = oci_core_vcn.terraform_vcn.default_dhcp_options_id
}