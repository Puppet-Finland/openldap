#
# == Define: openldap::config::File
#
# Create the slapd.conf file. The $databases variable gets it's actual content 
# from instances of openldap::database.
#
define openldap::config::file
(
    $ssl_enable,
    $logging,
    $schemas,
    $databases
)
{
    file { 'openldap-slapd.conf':
        name => '/etc/ldap/slapd.conf',
        ensure => present,
        content => template('openldap/slapd.conf.erb'),
        owner => root,
        group => openldap,
        mode => 640,
    }
}
