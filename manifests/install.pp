#
# == Class: openldap::install
#
# Install OpenLDAP and OpenLDAP utilities
#
class openldap::install inherits openldap::params {

    package { 'openldap-slapd':
        ensure => installed,
        name   => $::openldap::params::slapd_package_name,
    }

    package { 'openldap-ldap-utils':
        ensure => installed,
        name   => $::openldap::params::ldap_utils_package_name,
    }

}
