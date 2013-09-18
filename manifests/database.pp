#
# == Define: openldap::database
#
# Configure an OpenLDAP database. In practice, a slapd.conf configuration 
# fragment is created and slapd.conf updated to include that fragment. Note that 
# using this defined resource makes no sense unless 
# openldap::config::manage_config parameter is set to 'yes'.
#
# == Parameters
#
# [*title*]
#   While not strictly a parameter, the resource title is used to name the 
#   database configuration file fragment. To keep things clean don't use any 
#   special characters or spaces in the title.
# [*datadir*]
#   The directory where the database is stored. Defaults to '/var/lib/ldap'.
# [*suffix*]
#   Suffix for the primary database. Example: "dc=domain, dc=com".
# [*rootdn*]
#   Root DN for the primary database. Example: "cn=admin, dc=domain, dc=com".
# [*db_cachesize*]
#   Size of the database cache in bytes. Defaults to 2097152.
# [*indexes*]
#   An array containing indexes to generate. Defaults to [ 'objectClass eq' ].
# [*acls*]
#   A (huge) string containing the access control rules. Although this 
#   implementation is fairly crude, it's also much simpler than some of the 
#   alternatives such as embedding templates into templates. The only relatively 
#   simple alternative would have been to set the ACL rules in a "magic", 
#   site-specific file distributed by the Puppet fileserver, but that would have 
#   moved configuration details away from the node definition.
# [*extra_config*]
#   A (possibly huge) string containing additional database-specific 
#   configuration. The same rationale applies as for $acls above. Defaults to 
#   ''.
#
# == Examples
# 
# openldap::database { 'company':
#   suffix => 'dc=company,dc=com',
#   rootdn => 'cn=admin,dc=company,dc=com',
#   acls =>
# '
# access to attrs=userPassword,shadowLastChange
#        by dn="cn=admin,dc=company,dc=com" write
#        by anonymous auth
#        by self write
#        by * none
#
# access to dn.base="" by * read
#
# access to *
#        by dn="cn=admin,dc=company,dc=com" write
#        by * read
# '
# }
#
define openldap::database
(
    $datadir = '/var/lib/ldap',
    $suffix,
    $rootdn,
    $db_cachesize = 2097152,
    $indexes = [ 'objectClass eq' ],
    $acls,
    $extra_config=''
)
{

    # Database directory
    file { "openldap-data_dir-${title}":
        name => "${datadir}",
        ensure => directory,
        owner => openldap,
        group => openldap,
        mode => 700,
        # This not required per se, but we don't any directories to be created 
        # unless we've included this class.
        require => Class['openldap::config'],
    }

    # Configuration fragment for this database
    file { "openldap-database-config-${title}":
        name => "/etc/ldap/slapd.conf.d/${title}-database.conf",
        ensure => present,
        content => template('openldap/database.erb'),
        owner => root,
        group => openldap,
        mode => 640,
        require => Class['openldap::config'],
    }

    # Add this database to list of include files in slapd.conf
    Openldap::Config::File <| title == 'default-slapd.conf' |> {
        databases +> "${title}-database",
    }
}
