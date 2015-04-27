# openldap

Puppet module to handle OpenLDAP installation and configuration.

Currently this module only supports the slapd.conf-style configuration of 
OpenLDAP. Previously there was also some support for cn=config configuration 
backend, but the support was pulled out in commit 9c5158bb - primarily because 
it was a maintenance nightmare. That said, cn=config support could be 
reimplemented in a maintainable fashion with help from the datacentred-ldap 
module:

<https://github.com/datacentred/datacentred-ldap>

That module's ldap_entry resource is already being used in the dirsrv module:

<https://github.com/Puppet-Finland/dirsrv>

# Module usage

* [Class: openldap](manifests/init.pp)
* [Define: openldap::database](manifests/database.pp)

# Dependencies

See [metadata.json](metadata.json).

# Operating system support

This module has been tested on

* Ubuntu 12.04 and 14.04

Any *NIX-like operating system should be work with small modifications.

For details see [params.pp](manifests/params.pp).
