#
# default values in data/common.yaml
#
class bootstrap_infra::setup::tftp(
  Array[String] $dirs,
  Array[String] $packages,
) {


  file { $dirs:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  ensure_resource('package', $packages, {'ensure' => 'installed'})

}
