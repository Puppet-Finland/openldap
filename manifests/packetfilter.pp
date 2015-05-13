#
# == Class: openldap::packetfilter
#
# Limits access to openldap based on IP-address/range
#
class openldap::packetfilter
(
    $allow_ipv4_address,
    $allow_ipv6_address,
    $allow_ports
)
{

    $source_ipv4 = $allow_ipv4_address ? {
        'any'   => undef,
        default => $allow_ipv4_address,
    }

    $source_ipv6 = $allow_ipv6_address ? {
        'any'   => undef,
        default => $allow_ipv6_address,
    }

    # IPv4 rules
    firewall { '013 ipv4 accept ldap port':
        provider => 'iptables',
        chain    => 'INPUT',
        proto    => 'tcp',
        port     => $allow_ports,
        source   => $source_ipv4,
        action   => 'accept'
    }

    # IPv6 rules
    firewall { '013 ipv6 accept ldap port':
        provider => 'ip6tables',
        chain    => 'INPUT',
        proto    => 'tcp',
        port     => $allow_ports,
        source   => $source_ipv6,
        action   => 'accept',
    }
}
