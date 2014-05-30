#
# == Class: openldap::params
#
# Defines some variables based on the operating system
#
class openldap::params {

    case $::osfamily {
        'Debian': {
            $slapd_package_name = 'slapd'
            $ldap_utils_package_name = 'ldap-utils'
            $service_name = 'slapd'
            $service_start = "/usr/sbin/service $service_name start"
            $service_stop = "/usr/sbin/service $service_name stop"
            $pidfile = '/var/run/slapd/slapd.pid'
        }
        default: {
            $slapd_package_name = 'slapd'
            $ldap_utils_package_name = 'ldap-utils'
            $service_name = 'slapd'
            $service_start = "/usr/sbin/service $service_name start"
            $service_stop = "/usr/sbin/service $service_name stop"
            $pidfile = '/var/run/slapd/slapd.pid'
        }
    }
}
