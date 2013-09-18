#
# == Class: openldap::config::debian
#
# Debian-specific OpenLDAP configuration
#
class openldap::config::debian
(
    $interface,
    $ssl_enable
)
{

    # Setup the standard listener
    if $ssl_enable == 'yes' {
        $base_slapd_services = "ldaps://${interface}:636"
    } else {
        $base_slapd_services = "ldap://${interface}:389"
    }

    # Setup a non-SSL listener on locahost. We can't just add the listener 
    # above, as slapd will choke if it finds two identical listeners.
    if $ssl_enable == 'no' and $interface == '127.0.0.1' {
        $slapd_services = 'ldap://127.0.0.1:389'
    } else {
        $slapd_services = "ldap://127.0.0.1:389 $base_slapd_services"
    }

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
