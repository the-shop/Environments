class git_clone (
  $repositories
) {
  each( $repositories ) |$index, $data| {
    vcsrepo { "${data['value']['destination']}":
      provider => git,
      force    => true,
      ensure   => latest,
      require  => [ Package["git"] ],
      source   => $data['value']['source'],
      revision => $data['value']['revision'],
    }
    -> exec {"Composer run for ${data['value']['source']}" :
      command     => "composer -d=${data['value']['destination']} install",
      environment => ["COMPOSER_HOME=/root"],
      cwd         => $data['value']['destination'],
      path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
      logoutput   => true,
      timeout     => 0,
      onlyif      => "test ! -d ${data['value']['destination']}/vendor"
    }
  }
}