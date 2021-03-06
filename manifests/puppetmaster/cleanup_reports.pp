class puppet::puppetmaster::cleanup_reports {
  case $puppetmaster_reports_dir { '',undef: { $puppetmaster_reports_dir = '/var/lib/puppet/reports' } }
  # clean up reports older than $puppetmaster_cleanup_reports days
  file { '/etc/cron.daily/puppet_reports_cleanup':
    content => "#!/bin/bash\nfind ${puppetmaster_reports_dir} -maxdepth 2 -type f -ctime +${puppetmaster_cleanup_reports} -exec rm {} \\;\n",
    owner => root, group => 0, mode => 0700;
  }
}
