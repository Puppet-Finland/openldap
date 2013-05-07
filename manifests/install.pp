#
# == Class: openldap::install
#
# Install OpenLDAP and OpenLDAP utilities
#
class openldap::install {

    package { 'openldap-slapd':
        name => 'slapd',
        ensure => installed,
    }

    package { 'openldap-ldap-utils':
        name => 'ldap-utils',
        ensure => installed,
    }

}
