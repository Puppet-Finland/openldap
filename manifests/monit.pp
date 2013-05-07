#
# == Class: openldap::monit
#
# Setup local monitoring for openldap using monit
#
class openldap::monit {
    monit::fragment { 'openldap-slapd.monit':
        modulename => 'openldap',
        basename => 'slapd',
    }
}
