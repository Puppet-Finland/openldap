#
# == Define: openldap::database
#
# Configure an OpenLDAP database
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
#
# == Examples
#
define openldap::database
(
    $datadir = '/var/lib/ldap',
    $suffix,
    $rootdn,
    $db_cachesize = 2097152,
    $indexes = [ 'objectClass eq' ]
)
{

    # Database directory
    file { "openldap-data_dir-${title}":
        name => "${datadir}",
        ensure => directory,
        owner => openldap,
        group => openldap,
        mode => 700,
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
