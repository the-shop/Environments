class the_shop_mass_apache (
  $apache,
  $php,
  $hhvm
) {
  file {"/var/www/BoxData/GenericLAMP/":
    ensure => directory
  }
  # TODO: use apache puppet module for configuring this
  ->file {"/etc/apache2/sites-available/mass.conf":
    ensure => present,
    source => $apache['mass_vhost_source']
  }
  -> file {"/etc/apache2/sites-enabled/mass.conf":
    ensure => link,
    target => "/etc/apache2/sites-available/mass.conf"
  }

}