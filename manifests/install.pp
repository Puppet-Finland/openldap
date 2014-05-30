#
# == Class: openldap::install
#
# Install OpenLDAP and OpenLDAP utilities
#
class openldap::install {

    include openldap::params

    package { 'openldap-slapd':
        name => "${::openldap::params::slapd_package_name}",
        ensure => installed,
    }

    package { 'openldap-ldap-utils':
        name => "${::openldap::params::ldap_utils_package_name}",
        ensure => installed,
    }

}
