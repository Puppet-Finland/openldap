#
# == Class: openldap::config
#
# Manage base configuration of OpenLDAP
#
class openldap::config
(
    $ssl_enable,
    $logging,
    $schemas,
    $modules
)
{

    # Ensure a fragment directory is present
    file { 'openldap-slapd.conf.d':
        name => '/etc/ldap/slapd.conf.d',
        ensure => directory,
        owner => root,
        group => openldap,
        mode => 750,
    }

    # Create the actual configuration file, but don't realize it yet. For 
    # rationale see these files:
    #
    # postgresql/manifests/config/auth.pp
    # rsnapshot/manifests/config.pp
    #
    @openldap::config::file { 'default-slapd.conf':
        ssl_enable => $ssl_enable,
        logging => $logging,
        schemas => $schemas,
        modules => $modules,
        databases => [],
    }
}
