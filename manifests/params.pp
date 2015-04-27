#
# == Class: openldap::params
#
# Defines some variables based on the operating system
#
class openldap::params {

    include ::os::params

    case $::osfamily {
        'Debian': {
            $slapd_package_name = 'slapd'
            $ldap_utils_package_name = 'ldap-utils'
            $service_name = 'slapd'
            $pidfile = '/var/run/slapd/slapd.pid'
            $slapd_user = 'openldap'
            $slapd_group = 'openldap'
        }
        default: {
            fail("Unsupported operating system ${::osfamily}")
        }
    }

    $service_start = "${::os::params::service_cmd} ${service_name} start"
    $service_stop = "${::os::params::service_cmd} ${service_name} stop"
}
