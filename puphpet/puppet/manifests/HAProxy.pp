class the_shop_haproxy (
  $boxes,
  $stats
) {
  class { 'haproxy':
    global_options   => {
      'log'     => "127.0.0.1 local0 notice",
      'chroot'  => '/var/lib/haproxy',
      'pidfile' => '/var/run/haproxy.pid',
      'maxconn' => '1000',
      'user'    => 'haproxy',
      'group'   => 'haproxy',
      'daemon'  => '',
      'stats'   => 'socket /var/lib/haproxy/stats',
    },
    defaults_options => {
      'log'     => 'global',
      'stats'   => 'enable',
      'option'  => [
        'redispatch',
        'httplog',
        'dontlognull',
      ],
      'retries' => '3',
      'mode'    => 'http',
      'timeout' => [
        'http-request 10s',
        'queue 1m',
        'connect 10s',
        'client 1m',
        'server 1m',
        'check 10s',
      ],
      'maxconn' => '5000',
    }
  }

  haproxy::listen { 'puppet00':
    collect_exported => false,
    ipaddress        => '0.0.0.0',
    ports            => '80',
    options          => {
      stats => [
        'enable',
        'uri /haproxy?stats',
        'realm Strictly\ Private',
        "auth ${stats['username']}:${stats['password']}",
      ],
      option => [
        'httpclose',
        'forwardfor',
      ],
      balance => 'roundrobin',
    },
  }
  each( $boxes ) |$index, $data| {
    haproxy::balancermember { $data['config']['server_name']:
      listening_service => 'puppet00',
      server_names      => $data['config']['server_name'],
      ipaddresses       => $data['config']['ip'],
      ports             => '80',
      options           => 'check',
    }
  }
}