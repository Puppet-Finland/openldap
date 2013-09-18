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
# [*ssl_enable*]
#   Whether to use SSL. Defaults to 'no'. 
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
    $ssl_enable = 'no',    
    $allow_ipv4_address = '127.0.0.1',
    $allow_ipv6_address = '::1',
    $monitor_email = $::servermonitor
)
{
# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_openldap', 'true') != 'false' {

    include openldap::install

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
