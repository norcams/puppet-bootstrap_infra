#
define bootstrap_infra::install::tftp (
  Enum['present', 'absent'] $ensure = 'present',
  String $domain                    = $bootstrap_infra::domain,
  String $certname                  = "${name}.${domain}",
  String $hostname                  = "${name}.${domain}",
  String $image_repo                = $bootstrap_infra::mirror,
  String $kernel_opts               = 'net.ifnames=0',
  String $macaddress                = 'default',
  String $dhcp_interface            = $bootstrap_infra::host_interface,
  String $dhcp_range_start          = '10.0.0.10',
  String $dhcp_range_end            = '10.0.0.10',
  String $dhcp_gateway              = '10.0.0.1',
  String $rootpw                    = $bootstrap_infra::rootpw,
  Boolean $use_dhcp                 = true,
  Optional[String] $node_ip         = undef,
  Optional[String] $node_netmask    = undef,
  Optional[String] $node_gateway    = undef,
  Integer $maxsize                  = 10240
) {

  require bootstrap_infra::setup::tftp

  $dhcp_interface_ip = inline_template("<%= scope.lookupvar('::ipaddress_${dhcp_interface}') %>")
  $ks_url = "http://${dhcp_interface_ip}:8000/${name}.cfg"

  if $macaddress == 'default' {
    file { '/var/lib/tftpboot/pxelinux.cfg/default':
      ensure  => $ensure,
      content => template("${module_name}/pxelinux.erb"),
    }
  } else {
    $pxelinux_i = regsubst($macaddress,':','-','G')
    $pxelinux_file = downcase($pxelinux_i)

    file { "/var/lib/tftpboot/pxelinux.cfg/01-${pxelinux_file}":
      ensure  => $ensure,
      content => template("${module_name}/pxelinux.erb"),
    }
  }

  file { "/usr/local/sbin/bootstrap-${name}.sh":
    ensure  => $ensure,
    content => template("${module_name}/bootstrap/tftp.sh.erb"),
    mode    => '0755',
  }

  # kickstart file
  $kickstart = {
    ensure => $ensure,
    disable_ifnames => $kernel_opts =~ /.*net\.ifnames=0.*/? { true => true, default => false },
    maxsize => $maxsize,
    use_dhcp => $use_dhcp,
    rootpw => $rootpw,
    node_ip => $node_ip,
    node_netmask => $node_netmask,
    node_gateway => $node_gateway,
  }

  create_resources('::bootstrap_infra::kickstart', $name => $kickstart, $bootstrap_infra::kickstart_defaults)

}
