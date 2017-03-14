# == Class: sysctl
#
# concat order:
# 00: base
# 58: custom settings banner
# 59: custom settings
#
class sysctl(
              $manage_service                         = true,
              $manage_docker_service                  = false,
              $disable_ipv6                           = true,
              $sysrq                                  = false,
              $core_uses_pid                          = true,
              $ipv4_tcp_syncookies                    = true,
              $disable_netfilter_on_bridges           = true,
              $execshield                             = true,
              $randomize_va_space                     = '1',
              $suid_dumpable                          = false,
              $shmall                                 = '4294967296',
              $shmmax                                 = '68719476736',
              $msgmax                                 = '65536',
              $msgmnb                                 = '65536',
              $ipv4_ip_forward                        = false,
              $ipv4_icmp_echo_ignore_broadcasts       = true,
              $ipv4_icmp_ignore_bogus_error_responses = true,
              $ipv4_all_log_martians                  = true,
              $ipv4_default_log_martians              = true,
              $ipv4_all_accept_source_route           = false,
              $ipv4_default_accept_source_route       = false,
              $ipv4_all_rp_filter                     = true,
              $ipv4_default_rp_filter                 = true,
              $ipv4_all_accept_redirects              = false,
              $ipv4_default_accept_redirects          = false,
              $ipv4_all_secure_redirects              = false,
              $ipv4_default_secure_redirects          = false,
              $ipv4_all_send_redirects                = false,
              $ipv4_default_send_redirects            = false,
            ) inherits sysctl::params {

  Exec{
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  concat { '/etc/sysctl.conf':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Class['sysctl::service'],
  }

  concat::fragment{ 'base sysctl':
    target  => '/etc/sysctl.conf',
    content => template("${module_name}/sysctlbase.erb"),
    order   => '00',
  }

  class { 'sysctl::service':
    manage_service        => $manage_service,
    manage_docker_service => $manage_docker_service,
  }

}
