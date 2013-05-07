#
# == Define: openldap::config::option
#
# Set value of an attribute for the given dn.
#
# == Parameters
#
# [*dn*]
#   Distinguished name of the object to modify
# [*attribute*]
#   Name of the attribute to modify
# [*value*]
#   Value for the attribute
# [*changemode*]
#   Modification type. Either "add" (to add a value) or "replace" (to replace a 
#   value.
#
# == Examples
#
# openldap::config::option { 'openldap-hdb-option-rootdn':
#   dn => 'olcDatabase={1}hdb, cn=config',
#   attribute => 'olcRootDN',
#   value => $rootdn,
#   changemode => 'replace',
# }
#
define openldap::config::option(
    $dn,
    $attribute,
    $value,
    $changemode='replace'
)
{
    # Copy the LDIF file to a temporary location
    file { "openldap-${dn}-${attribute}":
        name => "/etc/ldap/puppet/${dn}-${attribute}.ldif",
        content => template('openldap/change.ldif.erb'),
        ensure => present,
        owner => root,
        group => root,
        mode => 600,
        require => File['openldap-puppet'],
    }

    # Load the LDIF file, if it has changed since last time
    exec { "openldap-${dn}-${attribute}":
        command => "ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f \"${dn}-${attribute}.ldif\"",
        path => '/usr/bin',
        cwd => '/etc/ldap/puppet',
        subscribe => File["openldap-${dn}-${attribute}"],
        refreshonly => true,
    }
}
