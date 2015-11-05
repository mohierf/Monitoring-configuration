# Adding an host in the monitoring

## Declaring a new host

```
   # On the main Shinken server
   su - shinken

   # Shinken hosts declaration are located here ...
   cd /etc/shinken/hosts

   # Hosts located on primary site are defined in the `main` subdirectory.
   cd main

   # Hosts located on secondary site are defined in the `second` subdirectory.
   # cd second

   # Copy an host file sample
   # - remote-poller.cfg, is a sample for a linux SNMP monitored host
   # - tpl-npre-01.cfg, is a sample for a linux NRPE monitored host
   # - tpl-win-01.cfg, is a sample for a Windows WMI monitored host

   # -------------------------------------
   # Windows sample
   cp tpl-win-01.cfg srv-win-01

   # Edit the new file
   vi srv-win-01.cfg

   # Set the host content
   # - in the use property:
   #     set company-main for hosts located in main center, or company-second for hosts in secondary center ...
   #     set top-for-business for the most important host
   #     set important for important hosts
   #     set production for "normal" hosts

   define host{
      use                     generic-host, windows, important, company-main
      contact_groups          admins
      host_name               srv-win-01
      alias                   Windows Server
      display_name            srv-win-01
      address                 192.168.0.1
   }
   # -------------------------------------

   # -------------------------------------
   # Linux SNMP sample
   cp remote-poller.cfg srv-snmp-01.cfg

   # Edit the new file
   vi srv-snmp-01.cfg

   # Set the host content
   # - in the use property:
   #     set company-main for hosts located in main center, or company-second for hosts in secondary center ...

   define host{
      use                     generic-host, linux-snmp, top-for-business, company-main
      contact_groups          admins
      host_name               img-srv-001
      alias                   Shinken remote poller
      display_name            img-srv-001
      address                 192.168.0.3
   }
   # -------------------------------------

   # -------------------------------------
   # Linux NRPE sample
   cp tpl-npre-01.cfg srv-nrpe-01.cfg

   # Edit the new file
   vi srv-nrpe-01.cfg

   # Set the host content
   # - in the use property:
   #     set company-main for hosts located in main center, or company-second for hosts in secondary center ...

   define host{
      use                     generic-host, linux-nrpe, important, company-main
      contact_groups          admins
      host_name               srv-nrpe-01
      alias                   Backup server
      display_name            srv-nrpe-01
      address                 192.168.168.249
   }
   # -------------------------------------

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
   root@shinken:~# /etc/init.d/shinken restart
   Restarting scheduler
   . ok
   Restarting poller
   . ok
   Restarting reactionner
   . ok
   Restarting broker
   . ok
   Restarting receiver
   . ok
   Restarting arbiter
   Doing config check
   . ok
   . ok

   # All must be ok, the new host is now monitored

```
