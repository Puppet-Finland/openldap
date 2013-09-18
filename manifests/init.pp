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
# [*manage_config*]
#   Whether or not to manage LDAP configuration. Valid values 'yes' and 'no'. 
#   You want to select 'no' if you're using cn=config, or don't want to manage 
#   slapd.conf (and some other configuration files) with this module. Defaults 
#   to 'no'.
# [*interface*]
#   The IP address of the interface on which to listen for requests. Defaults to 
#   '127.0.0.1'.
# [*ssl_enable*]
#   Whether to use SSL. Defaults to 'no'. 
# [*use_puppet_certs*]
#   Use puppet certs for SSL. Defaults to 'yes'.
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
#   IPv4 address/subnet from which to allow connections. Defaults to 127.0.0.1.
# [*allow_ipv6_address*]
#   IPv6 address/subnet from which to allow connections. Defaults to ::1.
# [*monitor_email*]
#   Email address where local service monitoring software sends it's reports to.
#   Defaults to global variable $::servermonitor.
#
# == Examples
#
# class {'openldap':
#   manage_config => 'yes',
#   interface => '0.0.0.0',
#   modules => 'syncprov',
#   ssl_enable => 'yes',
#   allow_ipv4_address => '192.168.0.0/24',
#   allow_ipv6_address => '::1',
# }
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-license
# See file LICENSE for details
#
class openldap
(
    $manage_config = 'no',
    $interface = '127.0.0.1',
    $ssl_enable = 'no',
    $use_puppet_certs = 'yes',
    $logging = 'none',
    $schemas = '', 
    $modules = '',
    $allow_ipv4_address = '127.0.0.1',
    $allow_ipv6_address = '::1',
    $monitor_email = $::servermonitor
)
{
# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_openldap', 'true') != 'false' {

    include openldap::install

    if ( $use_puppet_certs == 'yes' ) and ( $ssl_enable == 'yes' ) {
        include openldap::puppetcerts
    }

    if $manage_config == 'yes' {

        class { 'openldap::config':
            ssl_enable => $ssl_enable,
            logging => $logging,
            schemas => $schemas,
            modules => $modules,
        }

        # Debian requires some extra configuration steps
        if $osfamily == 'Debian' {
            class { 'openldap::config::debian':
                interface => $interface,
                ssl_enable => $ssl_enable,
            }
        }

    }

    include openldap::service

    if tagged('monit') {
        class { 'openldap::monit':
            monitor_email => $monitor_email,
        }
    }

    if tagged('packetfilter') {
        class { 'openldap::packetfilter':
            ssl_enable => $ssl_enable,
            allow_ipv4_address => $allow_ipv4_address,
            allow_ipv6_address => $allow_ipv6_address,
        }
    }
}
}
