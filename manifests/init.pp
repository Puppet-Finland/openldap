# == Class: openldap
#
# This class installs and configures openldap server.
#
# Note that commit ea7d3125 was the last one to contain (partial) support for 
# configuring OpenLDAP via cn=config. That functionality was removed for several 
# reasons. For example, many high-level configuration operations (such as adding 
# the ppolicy overlay) require several steps that need to be executed in the 
# correct order, or they will fail. Some of the steps affect the configdb, some 
# affect the actual LDAP tree. A failed Puppet run will result in a OpenLDAP 
# server configuration that's incomplete, and manual intervention becomes 
# necessary. Ordering the configuration steps using Puppet Requires or Run 
# Stages is not straightforward, unless we're content with fairly site-specific 
# classes and defines, or with creating hidden dependencies between the node 
# definitions and the classes/defines.
#
# All in all managing cn=config with (or without) Puppet is nasty business. 
# Managing the slapd.conf with (or without) Puppet is much more straightforward.
#
# == Parameters
#
# [*manage*]
#   Whether to manage OpenLDAP with Puppet or not. Valid values are true 
#   (default) and false.
# [*manage_config*]
#   Whether or not to manage LDAP configuration. Valid values true and false 
#   (default). Use the default (false) if you're using cn=config, or don't want 
#   to manage slapd.conf (and some other configuration files) with this module.
# [*listeners*]
#   A string containing all the slapd listeners. Remember that for ldaps:// 
#   listeners to work $ssl_enable has to be 'yes'. Example:
#
#   'ldaps://0.0.0.0:636 ldap://127.0.0.1:389'
#
#  Default value is 'ldap://127.0.0.1:389'.
# [*ssl_enable*]
#   Whether to use SSL. Valid values true and false (default).
# [*tls_verifyclient*]
#   Whether to verify client SSL certificates. Only makes sense if SSL is 
#   enabled. Valid values 'never', 'allow', 'try' and 'demand'. Defaults to 
#   'never'. Note that a bug in OpenLDAP may force you to use 'never' if you 
#   want to allow non-SSL clients.
# [*use_puppet_certs*]
#   Use puppet certs for SSL. Valid values true (default) and false.
# [*logging*]
#   Loglevel to use. See OpenLDAP documentation for the details. Defaults to 
#   'none'. This parameter is named slightly confusingly because 'loglevel' is a 
#   Puppet metaparameter and thus reserved for other purposes.
# [*schemas*]
#   An array of _basenames_ of additional schema files to load. The path 
#   '/etc/ldap/schema/' is prepended and '.schema' is appended to each 
#   automatically.
# [*modules*]
#   An array of additional slapd modules to load.
# [*allow_ipv4_address*]
#   IPv4 address/subnet from which to allow connections. Use 'any' for any 
#   address. Defaults to 127.0.0.1.
# [*allow_ipv6_address*]
#   IPv6 address/subnet from which to allow connections. Use 'any' for any 
#   address. Defaults to ::1.
# [*allow_ports*]
#   Port to open in the firewall (if it's enabled). Somewhat redundant, but much 
#   simpler than creating separate defines for each listener. Defaults to '389'.
# [*monitor_email*]
#   Email address where local service monitoring software sends it's reports to.
#   Defaults to global variable $::servermonitor.
#
# == Examples
#
#   class {'openldap':
#       manage_config => 'yes',
#       listeners => 'ldaps://0.0.0.0:636',
#       modules => 'syncprov',
#       ssl_enable => 'yes',
#       allow_ipv4_address => '192.168.0.0/24',
#       allow_ipv6_address => '::1',
#   }
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class openldap
(
    Boolean $manage = true,
    Boolean $manage_config = false,
            $listeners = 'ldap://127.0.0.1:389',
    Boolean $ssl_enable = false,
            $tls_verifyclient = 'never',
    Boolean $use_puppet_certs = true,
            $logging = 'none',
            $schemas = undef,
            $modules = undef,
            $allow_ipv4_address = '127.0.0.1',
            $allow_ipv6_address = '::1',
            $allow_ports = [ '389' ],
            $monitor_email = $::servermonitor
)
{

if $manage {

    include ::openldap::install

    if ( $use_puppet_certs ) and ( $ssl_enable ) {
        include ::openldap::puppetcerts
    }

    if $manage_config {

        class { '::openldap::config':
            ssl_enable       => $ssl_enable,
            tls_verifyclient => $tls_verifyclient,
            logging          => $logging,
            schemas          => $schemas,
            modules          => $modules,
        }

        # Debian requires some extra configuration steps
        if $::osfamily == 'Debian' {
            class { '::openldap::config::debian':
                listeners  => $listeners,
                ssl_enable => $ssl_enable,
            }
        }

    }

    include ::openldap::service

    if tagged('monit') {
        class { '::openldap::monit':
            monitor_email => $monitor_email,
        }
    }

    if tagged('packetfilter') {
        class { '::openldap::packetfilter':
            allow_ipv4_address => $allow_ipv4_address,
            allow_ipv6_address => $allow_ipv6_address,
            allow_ports        => $allow_ports,
        }
    }
}
}
