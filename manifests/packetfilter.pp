#
# == Class: openldap::packetfilter
#
# Limits access to openldap based on IP-address/range
#
class openldap::packetfilter(
    $allow_ipv4_address,
    $allow_ipv6_address
)
{

    # IPv4 rules
    firewall { "013 ipv4 accept ldaps port from $allow_ipv4_address":
        provider => 'iptables',
        chain => 'INPUT',
        proto => 'tcp',
        port => 636,
        source => "$allow_ipv4_address",
        action => 'accept',
    }

    # IPv6 rules
    firewall { "013 ipv6 accept ldaps port from $allow_ipv6_address":
        provider => 'ip6tables',
        chain => 'INPUT',
        proto => 'tcp',
        port => 636,
        source => "$allow_ipv6_address",
        action => 'accept',
    }

}
