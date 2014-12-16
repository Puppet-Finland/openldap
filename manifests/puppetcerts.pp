#
# == Class: openldap::puppetcerts
#
# Copy puppet certificates to a place where openldap can find them. This 
# approach is very similar to what's used in bacula::puppetcerts.
#
class openldap::puppetcerts {

    include puppetagent::params

    file { 'openldap-ssl-dir':
        ensure => directory,
        name => "/etc/ldap/ssl",
        owner => root,
        group => openldap,
        mode => 750,
        require => Class['openldap::install'],
    }

    exec { 'copy-puppet-cert-to-openldap.crt':
        command => "cp -f ${::puppetagent::params::ssldir}/certs/$fqdn.pem /etc/ldap/ssl/openldap.crt",
        unless => "cmp ${::puppetagent::params::ssldir}/certs/$fqdn.pem /etc/ldap/ssl/openldap.crt",
        path => ['/bin', '/usr/bin/' ],
        require => File['openldap-ssl-dir'],
    }

    exec { 'copy-puppet-key-to-openldap.key':
        command => "cp -f ${::puppetagent::params::ssldir}/private_keys/$fqdn.pem /etc/ldap/ssl/openldap.key",
        unless => "cmp ${::puppetagent::params::ssldir}/private_keys/$fqdn.pem /etc/ldap/ssl/openldap.key",
        path => ['/bin', '/usr/bin/' ],
        require => File['openldap-ssl-dir'],
    }

    exec { 'copy-puppet-ca-cert-to-openldap-ca.crt':
        command => "cp -f ${::puppetagent::params::ssldir}/certs/ca.pem /etc/ldap/ssl/openldap-ca.crt",
        unless => "cmp ${::puppetagent::params::ssldir}/certs/ca.pem /etc/ldap/ssl/openldap-ca.crt",
        path => ['/bin', '/usr/bin/' ],
        require => File['openldap-ssl-dir'],
    }

    file { 'openldap.crt':
        name => "/etc/ldap/ssl/openldap.crt",
        owner => root,
        group => openldap,
        mode => 644,
        require => Exec['copy-puppet-cert-to-openldap.crt'],
    }

    file { 'openldap.key':
        name => "/etc/ldap/ssl/openldap.key",
        owner => root,
        group => openldap,
        mode => 640,
        require => Exec['copy-puppet-key-to-openldap.key'],
    }

    file { 'openldap-ca.crt':
        name => "/etc/ldap/ssl/openldap-ca.crt",
        owner => root,
        group => openldap,
        mode => 644,
        require => Exec['copy-puppet-ca-cert-to-openldap-ca.crt'],
    }
}
