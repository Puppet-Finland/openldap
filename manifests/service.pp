#
# == Class: openldap::service
#
# Enable openldap service
#
class openldap::service inherits openldap::params {

    service { 'openldap':
        name    => $::openldap::params::service_name,
        enable  => true,
        require => Class['openldap::install'],
    }
}
