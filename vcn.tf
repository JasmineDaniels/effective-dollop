resource "oci_core_vcn" "terraform_vcn" {
    cidr_block = "10.5.0.0/16"
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


# Create security list to allow internet access from compute and ssh access

resource "oci_core_security_list" "app_sl" {
  compartment_id = var.compartment_id
  display_name   = "app-backends-sl"
  vcn_id         = oci_core_vcn.terraform_vcn.id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = 22
      min = 22
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = 80
      min = 80
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "10.5.0.0/24"

    tcp_options {
      max = 5000
      min = 5000
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "10.5.0.0/16"

    icmp_options {
        #Required
        type = 3
    }
  }
}

resource "oci_core_security_list" "LB_sl" {
  compartment_id = var.compartment_id
  display_name   = "LB-sl"
  vcn_id         = oci_core_vcn.terraform_vcn.id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  egress_security_rules {
    protocol    = "6"
    destination = "10.5.1.0/24"

    tcp_options {
      max = 5000
      min = 5000
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = 22
      min = 22
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = 80
      min = 80
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "10.5.0.0/16"

    icmp_options {
        #Required
        type = 3
    }
  }
}


resource "oci_core_subnet" "subnet_1" {
    #cidr_block = "10.1.20.0/24"
    cidr_block = "10.5.1.0/24"
    display_name = "tf_backends_subnet"
    dns_label = "testPrivate"
    #security_list_ids = [oci_core_vcn.terraform_vcn.default_security_list_id]
    security_list_ids = [resource.oci_core_security_list.app_sl.id]
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.terraform_vcn.id
    route_table_id = oci_core_vcn.terraform_vcn.default_route_table_id
    dhcp_options_id = oci_core_vcn.terraform_vcn.default_dhcp_options_id
}

resource "oci_core_subnet" "subnet_2" {
    cidr_block = "10.5.0.0/24"
    display_name = "tf_LB_subnet"
    dns_label = "testPublic"
    security_list_ids = [resource.oci_core_security_list.LB_sl.id]
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.terraform_vcn.id
    route_table_id = oci_core_vcn.terraform_vcn.default_route_table_id
    dhcp_options_id = oci_core_vcn.terraform_vcn.default_dhcp_options_id
}