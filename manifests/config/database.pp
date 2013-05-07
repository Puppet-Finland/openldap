#
# == Define: openldap::config::database
#
# This define is used to configure OpenLDAP database settings stored in the 
# configdb. This define leverages on the openldap::config::option define to 
# actually set the parameters.
#
# NOTE: this will only work if OpenLDAP install scripts actually creates a 
# database.
#
# == Parameters
#
# [*dn*]
#   The dn on the database
# [*suffix*]
#   The suffix of the database
# [*rootdn*]
#   Distinguished name of the root user
# [*rootpw*]
#   Password of the root user
#
# == Examples
#
# openldap::config::database { 'openldap-primary-db':
#   dn => 'olcDatabase={1}hdb,cn=config',
#   suffix => 'dc=domain,dc=com',
#   rootdn => 'cn=admin,dc=domain,dc=com',
#   rootpw => 'ultrasecurepassword',
# }
#
define openldap::config::database(
    $dn,
    $suffix,
    $rootdn,
    $rootpw
)
{
    # Set database suffix
    openldap::config::option { 'openldap-suffix':
        dn => $dn,
        attribute => 'olcSuffix',
        value => $suffix
    }

    # Set database root dn
    openldap::config::option { 'openldap-rootdn':
        dn => $dn,
        attribute => 'olcRootDN',
        value => $rootdn
    }

    # Set database root password
    openldap::config::option { 'openldap-rootpw':
        dn => $dn,
        attribute => 'olcRootPW',
        value => $rootpw
    }
}
