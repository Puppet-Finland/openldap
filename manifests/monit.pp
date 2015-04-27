#
# == Class: openldap::monit
#
# Setup local monitoring for openldap using monit
#
class openldap::monit
(
    $monitor_email

) inherits openldap::params
{

    include ::openldap::params

    monit::fragment { 'openldap-slapd.monit':
        modulename => 'openldap',
        basename   => 'slapd',
    }
}
