#
define bootstrap_infra::install::libvirt(
  Enum['present', 'absent'] $ensure = 'present',
  String $domain                    = $bootstrap_infra::domain,
  String $certname                  = "${name}.${domain}",
  String $hostname                  = "${name}.${domain}",
  String $rootpw                    = $bootstrap_infra::rootpw,
  String $mirror                    = $bootstrap_infra::mirror,
  String $nameserver                = $bootstrap_infra::nameserver,
  String $libvirt_pool              = 'default',
  String $libvirt_network           = 'default',
  Optional[String] $install_ip      = undef,
  Optional[String] $install_netmask = undef,
  Optional[String] $install_gateway = undef,
  String $os_variant                = 'almalinux8',
  String $vm_console                = 'ttyS0,115200',
  Integer $vm_vcpus                 = 2,
  Integer $vm_memory                = 4096,
  Integer $root_size                = 12,
  Integer $maxsize                  = 10240
) {

  # interface IP used for ks_url and vnc
  $interface_ip = inline_template("<%= scope.lookupvar('::ipaddress_${bootstrap_infra::interface}') %>")
  $ks_url = "http://${interface_ip}:8000/${name}.cfg"

  file { "/usr/local/sbin/bootstrap-${name}.sh":
    ensure  => $ensure,
    content => template("${module_name}/bootstrap/libvirt.sh.erb"),
    mode    => '0755',
  }

  # kickstart file config
  # use bootstrap_infra::kickstart_defaults to override other defaults
  $kickstart = {
    ensure => $ensure,
    use_dhcp => empty($install_ip)? { true => true, default => false },
    maxsize => $maxsize,
    rootpw => $rootpw,
    install_ip => $install_ip,
    install_netmask => $install_netmask,
    install_gateway => $install_gateway,
  }

  create_resources('::bootstrap_infra::kickstart', $name => $kickstart, $bootstrap_infra::kickstart_defaults)

}
