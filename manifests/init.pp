#
class bootstrap_infra(
  String $domain,
  String $mirror,
  String $rootpw            = '$1$de0ytuAp$9wuB2AJxYQrEM9Hxa4Ihp/',
  String $timezone          = 'Europe/Oslo',
  String $keyboard          = 'no',
  String $nameserver        = '8.8.8.8',
  String $puppetrepo        = 'https://github.com/norcams/himlar',
  String $epelrepo          = 'https://download.iaas.uio.no/nrec/prod/el8/epel',
  String $interface         = 'eth1',
  Hash $kickstart_defaults  = {}
) {

}
