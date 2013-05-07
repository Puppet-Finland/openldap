#
# == Class: openldap::service
#
# Enable openldap service
#
class openldap::service {
    service { 'openldap':
        name => 'slapd',
        enable => true,
        require => Class['openldap::install'],
    }
}

