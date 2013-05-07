# == Class: openldap
#
# This class installs and configures openldap server.
#
# At the moment only the very basic things are configured. There are several 
# reasons for this, besides the fact that configuring cn=config using LDIFs is a 
# nasty business in general. For example, many high-level configuration 
# operations (such as adding the ppolicy overlay) require several steps that 
# need to be executed in the correct order, or they will fail. Some of the steps 
# affect the configdb, some affect the actual LDAP tree. A failed Puppet run 
# will result in the OpenLDAP server configuration that's incomplete, and manual 
# intervention becomes necessary. Ordering the configuration steps using Puppet 
# Requires or Run Stages is not straightforward, unless we're content with 
# fairly site-specific classes and defines, or with creating hidden dependencies 
# between the node definitions and the classes/defines.
#
# All in all, without proper OpenLDAP configuration types for Puppet it's best 
# to limit Puppet's configuration of OpenLDAP to minimum and bootstrap the 
# servers manually using (ordered and site-specific) scripts. The alternative 
# would be to use a separate fairly static, site-specific Puppet module for the 
# job.
#
# == Parameters
#
# [*configdb_rootpw*]
#   The root password for configdb. Without this LDAP binds to the configuration 
#   database won't be possible. No default value.
# [*allow_ipv4_address*]
#   IPv4 address/subnet from which to allow connections. Defaults to 127.0.0.1.
# [*allow_ipv6_address*]
#   IPv6 address/subnet from which to allow connections. Defaults to ::1.
#
# == Examples
#
# class {'openldap':
#   configdb_rootpw => 'mysecret',
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

class openldap(
    $configdb_rootpw,
    $allow_ipv4_address = '127.0.0.1',
    $allow_ipv6_address = '::1'
)
{
    include openldap::install

    class { 'openldap::config':
        configdb_rootpw => $configdb_rootpw,
    }

    include openldap::service

    if tagged('monit') {
        include openldap::monit
    }

    if tagged('packetfilter') {
        class { 'openldap::packetfilter':
            allow_ipv4_address => $allow_ipv4_address,
            allow_ipv6_address => $allow_ipv6_address,
        }
    }
}
