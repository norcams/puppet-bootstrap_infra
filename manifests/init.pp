#
# default values in data/common.yaml
#
class bootstrap_infra(
  String $domain,
  String $mirror,
  String $rootpw,
  String $timezone,
  String $keyboard,
  String $nameserver,
  String $puppetrepo,
  String $epelrepo,
  String $host_interface,
  Hash $kickstart_defaults,
) {

}
