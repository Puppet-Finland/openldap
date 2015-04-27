#
# == Class: openldap::config
#
# Manage base configuration of OpenLDAP
#
class openldap::config
(
    $ssl_enable,
    $tls_verifyclient,
    $logging,
    $schemas,
    $modules

) inherits openldap::params
{

    # Ensure a fragment directory is present
    file { 'openldap-slapd.conf.d':
        ensure => directory,
        name   => '/etc/ldap/slapd.conf.d',
        owner  => $::os::params::adminuser,
        group  => $::openldap::params::slapd_group,
        mode   => '0750',
    }

    # Create the actual configuration file, but don't realize it yet. For 
    # rationale see these files:
    #
    # postgresql/manifests/config/auth.pp
    # rsnapshot/manifests/config.pp
    #
    @openldap::config::file { 'default-slapd.conf':
        ssl_enable       => $ssl_enable,
        tls_verifyclient => $tls_verifyclient,
        logging          => $logging,
        schemas          => $schemas,
        modules          => $modules,
        databases        => [],
    }
}
