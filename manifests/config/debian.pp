#
# == Class: openldap::config::debian
#
# Debian-specific OpenLDAP configuration
#
class openldap::config::debian
(
    $listeners,
    $ssl_enable

) inherits openldap::params
{
    file { 'openldap-slapd':
        ensure  => present,
        name    => '/etc/default/slapd',
        content => template('openldap/slapd.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['openldap::install'],
    }
}
