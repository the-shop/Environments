$apache         = hiera_hash('apache', {})
$beanstalkd     = hiera_hash('beanstalkd', {})
$blackfire      = hiera_hash('blackfire', {})
$cron           = hiera_hash('cron', {})
$drush          = hiera_hash('drush', {})
$elasticsearch  = hiera_hash('elastic_search', {})
$firewall       = hiera_hash('firewall', {})
$hhvm           = hiera_hash('hhvm', {})
$locales        = hiera_hash('locale', {})
$mailhog        = hiera_hash('mailhog', {})
$mariadb        = hiera_hash('mariadb', {})
$mongodb        = hiera_hash('mongodb', {})
$mysql          = hiera_hash('mysql', {})
$nginx          = hiera_hash('nginx', {})
$nodejs         = hiera_hash('nodejs', {})
$php            = hiera_hash('php', {})
$postgresql     = hiera_hash('postgresql', {})
$python         = hiera_hash('python', {})
$rabbitmq       = hiera_hash('rabbitmq', {})
$redis          = hiera_hash('redis', {})
$rubyhash       = hiera_hash('ruby', {})
$server         = hiera_hash('server', {})
$solr           = hiera_hash('solr', {})
$sqlite         = hiera_hash('sqlite', {})
$users_groups   = hiera_hash('users_groups', {})
$vm             = hiera_hash('vagrantfile', {})
$wpcli          = hiera_hash('wpcli', {})
$xdebug         = hiera_hash('xdebug', {})
$xhprof         = hiera_hash('xhprof', {})
$git_clone      = hiera_hash('git_clone', {})
$haproxy        = hiera_hash('haproxy', {})
$magento2       = hiera_hash('magento2', {})

Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/', '/opt/puppetlabs/puppet/bin' ] }

include ::puphpet::params

node /^*loadbalancer$/ {
  if array_true($haproxy, 'install') {
    class { '::the_shop_haproxy':
      boxes => $haproxy['boxes'],
      stats => $haproxy['stats'],
    }
  }
}

node default {
  if array_true($apache, 'install') {
    class { '::puphpet_apache':
      apache => $apache,
      php    => $php,
      hhvm   => $hhvm
    }
  }

  if array_true($apache, 'mass_vhost') {
    # TODO: refactor params
    class { '::the_shop_mass_apache':
      apache => $apache,
      php    => $php,
      hhvm   => $hhvm
    }
  }

  if array_true($beanstalkd, 'install') {
    class { '::puphpet_beanstalkd':
      beanstalkd => $beanstalkd,
      apache     => $apache,
      hhvm       => $hhvm,
      nginx      => $nginx,
      php        => $php
    }
  }

  class { '::puphpet_cron':
    cron => $cron,
  }

  if array_true($drush, 'install') {
    class { '::puphpet_drush':
      drush => $drush,
      php   => $php,
      hhvm  => $hhvm
    }
  }

  if array_true($elasticsearch, 'install') {
    class { '::puphpet_elasticsearch':
      elasticsearch => $elasticsearch
    }
  }

  class { '::puphpet_firewall':
    firewall => $firewall,
    vm       => $vm
  }

  if array_true($hhvm, 'install') {
    class { '::puphpet_hhvm':
      hhvm => $hhvm
    }
  }

  if array_true($mailhog, 'install') {
    class { '::puphpet_mailhog':
      mailhog => $mailhog
    }
  }

  if array_true($mariadb, 'install') and ! array_true($mysql, 'install') {
    class { '::puphpet_mariadb':
      mariadb => $mariadb,
      apache  => $apache,
      nginx   => $nginx,
      php     => $php,
      hhvm    => $hhvm
    }
  }

  if array_true($mongodb, 'install') {
    class { '::puphpet_mongodb':
      mongodb => $mongodb,
      apache  => $apache,
      nginx   => $nginx,
      php     => $php
    }
  }

  if array_true($mysql, 'install') and ! array_true($mariadb, 'install') {
    class { '::puphpet_mysql':
      mysql  => $mysql,
      apache => $apache,
      nginx  => $nginx,
      php    => $php,
      hhvm   => $hhvm
    }
  }

  if array_true($nginx, 'install') {
    class { '::puphpet_nginx':
      nginx => $nginx
    }
  }

  if array_true($nodejs, 'install') {
    class { '::puphpet_nodejs':
      nodejs => $nodejs
    }
  }

  if array_true($php, 'install') {
    class { '::puphpet_php':
      php     => $php,
      mailhog => $mailhog
    }

    if array_true($blackfire, 'install') {
      class { '::puphpet_blackfire':
        blackfire => $blackfire,
      }
    }

    if array_true($xdebug, 'install') {
      class { '::puphpet_xdebug':
        xdebug => $xdebug,
        php    => $php
      }
    }

    if array_true($xhprof, 'install') {
      class { '::puphpet_xhprof':
        xhprof => $xhprof,
        apache => $apache,
        nginx  => $nginx,
        php    => $php,
      }
    }
  }

  if array_true($git_clone, 'install') {
    class { '::git_clone':
      repositories     => $git_clone['repositories'],
    }
  }

  if array_true($postgresql, 'install') {
    class { '::puphpet_postgresql':
      postgresql => $postgresql,
      apache     => $apache,
      nginx      => $nginx,
      php        => $php,
      hhvm       => $hhvm
    }
  }

  if array_true($python, 'install') {
    class { '::puphpet_python':
      python => $python
    }
  }

  if array_true($rabbitmq, 'install') {
    class { '::puphpet_rabbitmq':
      rabbitmq => $rabbitmq,
      apache   => $apache,
      nginx    => $nginx,
      php      => $php
    }
  }

  if array_true($redis, 'install') {
    class { '::puphpet_redis':
      redis  => $redis,
      apache => $apache,
      nginx  => $nginx,
      php    => $php
    }
  }

  class { '::puphpet_ruby':
    ruby => $rubyhash
  }

  class { '::puphpet_server':
    server  => $server
  }

  class { '::puphpet_locale':
    locales => $locales
  }

  if array_true($solr, 'install') {
    class { '::puphpet_solr':
      solr => $solr
    }
  }

  if array_true($sqlite, 'install') {
    class { '::puphpet_sqlite':
      sqlite => $sqlite,
      apache => $apache,
      nginx  => $nginx,
      php    => $php,
      hhvm   => $hhvm
    }
  }

  class { '::puphpet_usersgroups':
    users_groups => $users_groups,
  }

  if array_true($wpcli, 'install') {
    class { '::puphpet_wpcli':
      wpcli => $wpcli,
      php   => $php,
      hhvm  => $hhvm
    }
  }

  if array_true($magento2, 'install') {
    class { '::the_shop_magento2':
      source_tar_bz2 => $magento2['source_tar_bz2'],
      destination    => $magento2['destination'],
      webroot_user   => $magento2['user'],
      webroot_group  => $magento2['group'],
      install_data   => $magento2['install_data'],
    }
  }
}
