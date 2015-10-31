# Adding an host in the monitoring

## Declaring a new host

```
   # On the main Shinken server
   su - shinken

   # Shinken hosts declaration are here ...
   cd /etc/shinken/hosts

   # Hosts located on primary site (centro de distribução) are here ...
   cd main

   # Hosts located on secondary site (centrinho) are here ...
   # cd second

   # Copy an host file sample
   # - remote-poller.cfg, is a sample for a linux SNMP monitored host
   # - uvb-pm.cfg, is a sample for a linux NRPE monitored host
   # - img-srv-021.cfg, is a sample for a Windows WMI monitored host
   cp img-srv-021.cfg srv-dom01

   # Edit the new file
   vi srv-dom01.cfg

   # Set the host content
      host_name               srv-dom01
      alias                   Windows Server / Backup Server / NAS
      display_name            srv-dom01
      address                 192.168.168.8

   # Save the file

   # Check shinken configuration (there must be no errors)
   shinken-arbiter -v -c /etc/shinken/shinken.cfg

   # Last lines must be like this ... note hosts number to 14!
   [1446301825] INFO: [Shinken] Number of hosts in the realm All: 14 (distributed in 9 linked packs)
   [1446301825] INFO: [Shinken] Total number of hosts : 14
   [1446301825] INFO: [Shinken] Things look okay - No serious problems were detected during the pre-flight check

   # If errors are signaled, edit the file and fix the reported errors.

   # Restart Shinken
   su -
   /etc/init.d/shinken restart
```
