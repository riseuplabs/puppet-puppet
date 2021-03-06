# class to use passenger for serving puppetmaster

class puppet::puppetmaster::passenger inherits puppet::puppetmaster::base {

  include ::passenger

  # A reference configuration is available at :
  # http://github.com/reductivelabs/puppet/tree/master/ext/rack

  case $::operatingsystem {
    debian: {
      package { 'puppetmaster-passenger': ensure => installed }
      file {
        '/usr/share/puppet/rack/puppetmasterd/config.ru':
          source => [ 'puppet:///modules/site-puppet/master/config.ru',
                      'puppet:///modules/puppet/master/config.ru' ],
          owner  => puppet, group => 0, mode => '0644';
      }

      include apt

      apt::preferences_snippet {
        'puppet_passenger':
          package => 'puppet*',
          pin => "version $puppetmaster_ensure_version",
          priority => 2000,
          notify => Exec['refresh_apt'],
          before => Package['puppetmaster'];
      }
    }
    default: {
      file {
        ['/etc/puppet/rack', '/etc/puppet/rack/public', '/etc/puppet/rack/tmp']:
          ensure => directory,
          owner  => root, group => 0, mode => '0755';

        '/etc/puppet/rack/config.ru':
          source => [ 'puppet:///modules/site-puppet/master/config.ru',
                      'puppet:///modules/puppet/master/config.ru' ],
          owner  => puppet, group => 0, mode => '0644';
      }
    }
  }
}
