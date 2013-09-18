#
# == Class: openldap::monit
#
# Setup local monitoring for openldap using monit
#
class openldap::monit
(
    $monitor_email
)
{
    monit::fragment { 'openldap-slapd.monit':
        modulename => 'openldap',
        basename => 'slapd',
    }
}
