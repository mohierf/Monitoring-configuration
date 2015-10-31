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

## Check Windows servers (WMI checks)
```
   # Install Shinken commands for WMI checks
   su - shinken
   shinken install windows

   # Add a tag to concerned hosts ...
   # vi /etc/shinken/hosts/localhost.cfg
   # => use generic-host, windows     # Set windows template
```

## Prepare Windows host

Create a user account:

- username/password (example): shinken/shinken
- member of followinf groups: Administrators, Remote DCOM users
- Deactivate interactive login permissions (more secure)

Check that WMI and RPC services are started

The Windows Firewall must allow inbound trafic for:
   - Windows Firewall Remote Management (RPC)
   - Windows Management Instrumentation (DCOM-In)
   - Windows Management Instrumentation (WMI-In)

This page contains more information about remote WMI configuration: https://kb.op5.com/display/HOWTOs/Agentless+Monitoring+of+Windows+using+WMI


## Tests
```
   # Basic wmic command ...
   $ /var/lib/shinken/libexec/wmic -U .\\shinken%shinken //192.168.0.20 'Select Caption From Win32_OperatingSystem'

   # Shinken command ...
   $ /var/lib/shinken/libexec/check_wmi_plus.pl -H 192.168.0.20 -u ".\\shinken" -p "shinken" -m checkdrivesize -a '.'  -w 90 -c 95 -o 0 -3 1  --inidir=/var/lib/shinken/libexec
```

## Configuration

```
   # Checks pack location
   cd /etc/shinken/packs/windows

   # Specific configuration
   $ vi templates.cfg
   => Allow to set up specific credentials (else use previously defined)
   => Allow to set up services checks threshold

   # Disable some checks
   # Rename the services/service_name.cfg file to *.cfg_unused
   mv eventlogs_applications.cfg_ eventlogs_applications.cfg_unused
   mv eventlogs_system.cfg_ eventlogs_system.cfg_unused
   mv services.cfg_ services.cfg_unused
   mv swap.cfg_ swap.cfg_unused
   # Do this for:
   # swap, services, eventlogs_applications and eventlogs_system
   # Those services checks need very specific configuration ...
   # ... and they should be activated later.
```


## Checks examples

   First line: launched command
   Second line: check output
   Third line: performance data

Ping:
   /var/lib/shinken/libexec/check_ping -H 127.0.0.1 -w 1000,100% -c 3000,100% -p 1

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