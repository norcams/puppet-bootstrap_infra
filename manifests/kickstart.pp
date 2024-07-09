#
# Create anaconda kickstart file with mulitiple templates
#
# Network setup:
# * dhcp: use_dhcp=true (default)
# * static: set ip, netmask and gateway and use_dhcp=false
# * none: set use_dhcp=false
#
# Disk size:
# * use maxsize to change
#
# Defaults and templates:
# To change mulitple templates or vars for all nodes use
#   bootstrap_infra::kickstart_defaults hash
#
define bootstrap_infra::kickstart (
  Enum['present', 'absent'] $ensure = 'present',
  String $rootpw                    = undef,
  String $domain                    = $bootstrap_infra::domain,
  String $certname                  = "${name}.${domain}",
  String $hostname                  = "${name}.${domain}",
  String $mirror                    = $bootstrap_infra::mirror,
  String $timezone                  = $bootstrap_infra::timezone,
  String $keyboard                  = $bootstrap_infra::keyboard,
  String $nameserver                = $bootstrap_infra::nameserver,
  String $puppetrepo                = $bootstrap_infra::puppetrepo,
  String $epelrepo                  = $bootstrap_infra::epelrepo,
  Integer $maxsize                  = 10240,
  Boolean $disable_ifnames          = true,
  Boolean $use_dhcp                 = true,
  Optional[String] $node_ip         = undef,
  Optional[String] $node_netmask    = undef,
  Optional[String] $node_gateway    = undef,
  String $main_template             = "${module_name}/kickstart/main.erb",
  String $provision_template        = "${module_name}/kickstart/provision.erb",
  String $custom_template           = "${module_name}/kickstart/el8.erb",
  String $post_start_template       = "${module_name}/kickstart/post_start.erb",
  String $post_end_template         = "${module_name}/kickstart/post_end.erb",
) {

  concat { "/var/www/html/${name}.cfg":
    ensure => $ensure
  }

  concat::fragment { "${name}-main_template":
    target  => "/var/www/html/${name}.cfg",
    content => template($main_template),
    order   => '01'
  }

  concat::fragment { "${name}-post_start_template":
    target  => "/var/www/html/${name}.cfg",
    content => template($post_start_template),
    order   => '02'
  }

  concat::fragment { "${name}-custom_template":
    target  => "/var/www/html/${name}.cfg",
    content => template($custom_template),
    order   => '03'
  }

  concat::fragment { "${name}-provision_template":
    target  => "/var/www/html/${name}.cfg",
    content => template($provision_template),
    order   => '04'
  }

  concat::fragment { "${name}-post_end_template":
    target  => "/var/www/html/${name}.cfg",
    content => template($post_end_template),
    order   => '99'
  }

}
