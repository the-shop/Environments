class the_shop_magento2 (
  $source_tar_bz2,
  $destination,
  $webroot_user,
  $webroot_group,
  $install_data
) {
  # We need this in order to be able to install sample data
  $auth_json = "{
  \"http-basic\": {
    \"repo.magento.com\": {
      \"username\": \"${install_data['magento_connect_public_key']}\",
      \"password\": \"${install_data['magento_connect_private_key']}\"
    }
  }
}"

  $install_complete_file = '/tmp/magento-install-complete.txt'

  file {"Ensure ${destination} is empty":
    path => $destination,
    ensure => directory,
    purge => true,
    recurse => true,
    force => true,
    backup => false,
  }
  ->file {"${destination}/auth.json":
    ensure => file,
    content => $auth_json,
  }
  ->exec { "Download Magento2 installation (${source_tar_bz2})" :
    command => "wget --quiet --tries=5 --connect-timeout=10 -O /tmp/Magento2.tar.bz2 ${source_tar_bz2}",
    user    => $webroot_user,
    group   => $webroot_group,
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    onlyif  => "test ! -f /tmp/Magento2.tar.bz2",
    require  => [Class['Php::Devel'],Class['apache']],
    timeout     => 0,
  }
  -> exec { "Extract Magento2 installation to ${destination}" :
    command => "tar -xjvf /tmp/Magento2.tar.bz2 -C ${destination}",
    user    => $webroot_user,
    group   => $webroot_group,
    timeout     => 0,
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    onlyif  => "test ! -f ${destination}/composer.json"
  }
  -> exec {"Composer run for Magento2 @ ${destination}" :
    command     => "composer -d=${destination} install",
    environment => ["COMPOSER_HOME=/root"],
    cwd         => $destination,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    logoutput   => true,
    timeout     => 0,
    onlyif      => "test ! -f ${install_complete_file}",
  }
  -> exec {"Magento2 CHOWN @ ${destination}" :
    command     => "chown -R :www-data ${destination}",
    cwd         => $destination,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    logoutput   => true,
    timeout     => 0,
    onlyif      => "test ! -f ${install_complete_file}",
  }
  -> exec {"Magento2 CHOMOD directories @ ${destination}" :
    command     => "find ${destination} -type d -exec chmod 0770 {} \\;",
    cwd         => $destination,
    timeout     => 0,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    onlyif      => "test ! -f ${install_complete_file}",
    logoutput   => true
  }
  -> exec {"Magento2 CHOMOD files @ ${destination}" :
    command     => "find ${destination} -type f -exec chmod 0660 {} \\;",
    cwd         => $destination,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    logoutput   => true,
    timeout     => 0,
  onlyif      => "test ! -f ${install_complete_file}",
  }
  -> exec {"Magento2 CHOMOD binary bin/magento @ ${destination}" :
    command     => "chmod u+x ${destination}/bin/magento",
    cwd         => $destination,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    logoutput   => true,
    timeout     => 0,
    onlyif      => "test ! -f ${install_complete_file}",
  }
  -> exec {"Install Magento2 @ ${destination}" :
    command     => "php ${destination}/bin/magento setup:install --db-host=${install_data['db_host']} --db-name=${install_data['db_name']} --db-user=${install_data['db_user']} --db-password=${install_data['db_pass']} --admin-password=${install_data['admin_password']} --admin-email=${install_data['admin_email']} --admin-firstname=${install_data['admin_firstname']} --admin-lastname=${install_data['admin_lastname']} --admin-user=${install_data['admin_username']} --base-url={{base_url}} --backend-frontname=${install_data['backend_frontname']} --use-rewrites=1 --admin-use-security-key=1 --session-save=db",
    cwd         => $destination,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    logoutput   => true,
    timeout     => 0,
    onlyif      => "test ! -f ${install_complete_file}",
  }
  -> exec {"Install Magento2 sample data @ ${destination}" :
    command     => "php ${destination}/bin/magento sampledata:deploy",
    cwd         => $destination,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    logoutput   => true,
    timeout     => 0,
    onlyif      => "test ! -f ${install_complete_file}",
  }
  -> exec {"Run setup:upgrade to finish Magento2 sample data installation @ ${destination}" :
    command     => "php ${destination}/bin/magento setup:upgrade",
    cwd         => $destination,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    logoutput   => true,
    timeout     => 0,
    onlyif      => "test ! -f ${install_complete_file}",
  }
  ->file { "${install_complete_file}":
    ensure => present,
    replace => 'no',
    content => "If you delete me, provisioning will fail.",
  }
}