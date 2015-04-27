#
# == Define: openldap::config::File
#
# Create the slapd.conf file. The $databases variable gets it's actual content 
# from instances of openldap::database.
#
define openldap::config::file
(
    $ssl_enable,
    $tls_verifyclient,
    $logging,
    $schemas,
    $modules,
    $databases
)
{
    include ::openldap::params

    file { 'openldap-slapd.conf':
        ensure  => present,
        name    => '/etc/ldap/slapd.conf',
        content => template('openldap/slapd.conf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::openldap::params::slapd_group,
        mode    => '0640',
    }
}
