class puppet::puppetmaster::checklastrun {

  $puppet_lastruncheck_ignorehosts_str = $::puppet_lastruncheck_ignorehosts ? {
    ''      => '',
    undef   => '',
    default => "--ignore-hosts ${::puppet_lastruncheck_ignorehosts}"
  }

  $puppet_lastruncheck_timeout_str = $::puppet_lastruncheck_timeout ? {
    ''      => '',
    undef   => '',
    default => "--timeout ${::puppet_lastruncheck_timeout}"
  }

  include ::cron

  file{
    '/usr/local/sbin/puppetlast':
      source => [ 'puppet:///modules/puppet/master/lastruncheck' ],
      owner  => root,
      group  => 0,
      mode   => '0700';

    '/etc/cron.d/puppetlast':
      content => "${puppetmaster_lastruncheck_cron} root output=\$(/usr/local/sbin/puppetlast ${puppet_lastruncheck_timeout_str} ${puppet_lastruncheck_ignorehosts_str} ${$puppet_lastruncheck_additionaloptions} 2>&1) || echo \"\$output\"\n",
      require => File['/usr/local/sbin/puppetlast'],
      owner   => root,
      group   => 0,
      mode    => '0644',
      notify  => Service['cron'];

    # Cleanup cronjob previously installed under a buggy name.
    '/etc/cron.d/puppetlast.cron':
      ensure => absent;
  }
}
