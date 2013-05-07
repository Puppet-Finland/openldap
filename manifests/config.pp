#
# == Class: openldap::config
#
# Configures openldap server. This class only touches the configdb.
#
class openldap::config($configdb_rootpw) {

    # Create a directory for Puppet-distributed LDIF files
    file { 'openldap-puppet':
        name => '/etc/ldap/puppet',
        ensure => directory,
        owner => root,
        group => root,
        mode => 700,
        require => Class['openldap::install'],
    }

    # Set rootpw for the configdb using an LDIF file
    openldap::config::option { 'openldap-confdb-option-rootpw':
        dn => 'olcDatabase={0}config, cn=config',
        attribute => 'olcRootPW',
        value => $configdb_rootpw,
    }
}
