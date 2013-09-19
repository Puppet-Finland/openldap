#
# == Class: openldap::config::debian
#
# Debian-specific OpenLDAP configuration
#
class openldap::config::debian
(
    $listeners,
    $ssl_enable
)
{
    file { 'openldap-slapd':
        name => '/etc/default/slapd',
        ensure => present,
        content => template('openldap/slapd.erb'),
        owner => root,
        group => root,
        mode => 644,
        require => Class['openldap::install'],
    }
}
