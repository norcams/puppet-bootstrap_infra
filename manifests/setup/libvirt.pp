#
# default values in data/common.yaml
#
class bootstrap_infra::setup::libvirt(
  Array[String] $dirs,
  Hash $packages,
) {


  file { $dirs:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  create_resources('package', $packages, {'ensure' => 'installed'})

}
