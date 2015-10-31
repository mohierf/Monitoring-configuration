# SNMP checks for Linux servers

## My specific files ...
If not yet installed ...

```
   su - shinken
   # Fetching doc and extra files
   # Used later in the installation process
   wget https://github.com/mohierf/Monitoring-configuration/archive/master.tar.gz
   tar xvf master.tar.gz
   # cd Monitoring-configuration-master
```

## Check Linux servers (SNMP checks)
```
   # Install Shinken commands for SNMP checks
   su - shinken
   shinken install linux-snmp

   # Add a tag to concerned hosts ...
   # vi /etc/shinken/hosts/localhost.cfg
   # => use generic-host, linux-snmp     # Set linux-snmp template

   # Fix missing perl dependency when checks are launched from Shinken directory
   # !!! Fix Shinken bug !!!
   # NOTE: Run this command only if you did not installed WMI module!
   ln -s /usr/lib/nagios/plugins/utils.pm /var/lib/shinken/libexec/utils.pm

   # Update missing plugins
   # !!! Fix Shinken bug !!!
   cp ./Monitoring-configuration-master/plugins/check_netint.pl /var/lib/shinken/libexec/.
   # chown shinken:shinken /var/lib/shinken/libexec/check_netint.pl
   chmod 755 /var/lib/shinken/libexec/check_netint.pl
```

## Test

Testing the installation with the following commands:
```
   shinken@shinken:~$ /usr/lib/nagios/plugins/check_ping -H 127.0.0.1 -w 1000,100% -c 3000,100% -p 1
   PING OK - Packet loss = 0%, RTA = 0.08 ms|rta=0.076000ms;1000.000000;3000.000000;0.000000 pl=0%;100;100;0

   shinken@shinken:~$ /var/lib/shinken/libexec/check_snmp_mem.pl -w 80 -c 95 -- -v 2c -c public 127.0.0.1
   MEMORY OK: 4.24 % used; Free => 1300880 Kb, Total => 2052860 Kb, Cached => 610024 Kb, Buffered => 54904 Kb|ram_free=1300880 ram_total=2052860 ram_cached=610024 ram_buffered=54904
```

## Configuration

Some configuration is necessary in the default Shinken pack ...

Some updates are necessary in the default Shinken pack ... problems not fixed by the development team!

```
   # Checks pack location
   cd /etc/shinken/packs/linux-snmp

   # Specific configuration
   $ vi templates.cfg
   => Allow to set up the SNMP community used by the snmpget
   => Allow to set up services checks threshold

   # Disable some checks
   # Rename the services/service_name.cfg file to *.cfg_unused
   mv services/time.cfg_ services/time.cfg_unused
   mv services/logFiles.cfg services/logFiles.cfg_unused
   # Do this for:
   # time, logFiles
   # Those services checks need very specific configuration ...
   # ... and they should be activated later.
```

In the templates configuration file, apply the following modifications ...
```
shinken@shinken:/etc/shinken/packs/linux-snmp$ vi templates.cfg

   # The LINUX template.
   define host {
      ...

      # We will show the linux custom view
      #custom_views        +linux

      ...
      _NTP_SERVER         a.ntp.br
      _NTP_WARN           0.128
      _NTP_CRIT           1
   }
```


# Checks examples

   First line: launched command
   Second line: check output
   Third line: performance data

```
   Ping:
      /usr/lib/nagios/plugins/check_ping -H 127.0.0.1 -w 1000,100% -c 3000,100% -p 1

      PING OK - Packet loss = 0%, RTA = 0.04 ms

         |rta=0.038000ms;1000.000000;3000.000000;0.000000 pl=0%;100;100;0

   Memory:
      /var/lib/shinken/libexec/check_snmp_mem.pl -w 80 -c 95 -- -v 2c -c public 127.0.0.1

      MEMORY OK: 6.91 % used; Free => 898896 Kb, Total => 1027008 Kb, Cached => 42932 Kb, Buffered => 14192 Kb

         |ram_free=898896 ram_total=1027008 ram_cached=42932 ram_buffered=14192

   CPU:
      /var/lib/shinken/libexec/check_snmp_load.pl -H 127.0.0.1 -C public -f -w 80 -c 90 -o 65535

      1 CPU, load 1.0% < 80% : OK

         | cpu_prct_used=1%;80;90

   Load:
      /var/lib/shinken/libexec/check_snmp_load.pl -H 127.0.0.1 -C public -f -w 2,2,2 -c 3,3,3 -T netsl -o 65535

      Load : 0.03 0.03 0.05 : OK

         | load_1_min=0.03;2;3 load_5_min=0.03;2;3 load_15_min=0.05;2;3

   Disks:
      /var/lib/shinken/libexec/check_snmp_storage.pl -H 127.0.0.1 -C public -m / -f -w 90 -c 95 -S0,1 -o 65535

      OK : (<90%) All selected storages

         | '/'=1349MB;6915;7299;0;7683 '/dev'=0MB;9;10;0;10

   Network:
      /var/lib/shinken/libexec/check_netint.pl -H 192.168.0.41 -C public -n "eth\d+|em\d+" -g -2c -f -e -w 90,90,0,0,0,0 -c 0,0,0,0,0,0 -q -k -y -M -B -m -P "'eth0_in_prct'=0%;90;;0;100  'eth0_out_prct'=0%;90;;0;100  'eth0_in_octet'=149304019c 'eth0_out_octet'=148351058c 'eth0_in_error'=0 'eth0_out_error'=0 'eth0_in_discard'=0 'eth0_out_discard'=0 cache_descr_ids=2 cache_descr_names=eth0 cache_descr_time=1446198228 'eth0_in_octet.1446198825'=149060378 'eth0_out_octet.1446198825'=148086678 'eth0_in_error.1446198825'=0 'eth0_out_error.1446198825'=0 'eth0_in_discard.1446198825'=0 'eth0_out_discard.1446198825'=0 ptime=1446198930" -T "1446198930"  -o 65535

      eth0:UP (0.0Mbps/0.0Mbps/0.0/0.0/0.0/0.0) (1 UP): OK

         |  'eth0_in_prct'=0%;90;;0;100  'eth0_out_prct'=0%;90;;0;100  'eth0_in_octet'=150329751c 'eth0_out_octet'=149397176c 'eth0_in_error'=0 'eth0_out_error'=0 'eth0_in_discard'=0 'eth0_out_discard'=0 cache_descr_ids=2 cache_descr_names=eth0 cache_descr_time=1446198228 'eth0_in_octet.1446198930'=149304019 'eth0_out_octet.1446198930'=148351058 'eth0_in_error.1446198930'=0 'eth0_out_error.1446198930'=0 'eth0_in_discard.1446198930'=0 'eth0_out_discard.1446198930'=0 ptime=1446199291
```
