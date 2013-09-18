#
# == Class: openldap::packetfilter
#
# Limits access to openldap based on IP-address/range
#
class openldap::packetfilter(
    $ssl_enable,
    $allow_ipv4_address,
    $allow_ipv6_address
)
{

    if $ssl_enable == 'yes' {
        $ldap_port = 636
    } else {
        $ldap_port = 389
    }

    # IPv4 rules
    firewall { '013 ipv4 accept ldap port':
        provider => 'iptables',
        chain => 'INPUT',
        proto => 'tcp',
        port => $ldap_port,
        source => "$allow_ipv4_address",
        action => 'accept',
    }

    # IPv6 rules
    firewall { '013 ipv6 accept ldap port':
        provider => 'ip6tables',
        chain => 'INPUT',
        proto => 'tcp',
        port => $ldap_port,
        source => "$allow_ipv6_address",
        action => 'accept',
    }

}
