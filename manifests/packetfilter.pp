#
# == Class: openldap::packetfilter
#
# Limits access to openldap based on IP-address/range
#
class openldap::packetfilter(
    $allow_ipv4_address,
    $allow_ipv6_address,
    $allow_ports
)
{

    # IPv4 rules
    firewall { '013 ipv4 accept ldap port':
        provider => 'iptables',
        chain => 'INPUT',
        proto => 'tcp',
        port => $allow_ports,
        source => $allow_ipv4_address ? {
            'any' => undef,
            default => $allow_ipv4_address,
        },
        action => 'accept'
    }

    # IPv6 rules
    firewall { '013 ipv6 accept ldap port':
        provider => 'ip6tables',
        chain => 'INPUT',
        proto => 'tcp',
        port => $ports,
        source => $allow_ipv6_address ? {
            'any' => undef,
            default => $allow_ipv6_address,
        },
        action => 'accept',
    }

}
