# WMI checks for Windows servers

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

## Configure Windows remote credentials
```
   vi /etc/shinken/resource.d/active-directory.cfg
   =>
     $DOMAIN$=.
     $DOMAINUSERSHORT$=shinken
     $DOMAINUSER$=$DOMAIN$\\$DOMAINUSERSHORT$
     $DOMAINPASSWORD$=shinken
```

## Install PERL dependencies for check_wmi_plus plugin
```
   su -
   apt-get install libnumber-format-perl
   apt-get install libconfig-inifiles-perl
   apt-get install libdatetime-perl
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

## Hosts specific configuration

The main `windows` template declares macros used to configure the launched checks. The default values of these macros listed hereunder can be overriden in each host configuration.

```
   _DOMAIN                          $DOMAIN$
   _DOMAINUSERSHORT                 $DOMAINUSERSHORT$
   _DOMAINUSER                      $_HOSTDOMAIN$\\$_HOSTDOMAINUSERSHORT$
   _DOMAINPASSWORD                  $DOMAINPASSWORD$

   _WINDOWS_DISK_WARN               90
   _WINDOWS_DISK_CRIT               95
   _WINDOWS_EVENT_LOG_WARN          1
   _WINDOWS_EVENT_LOG_CRIT          2
   _WINDOWS_REBOOT_WARN             15min:
   _WINDOWS_REBOOT_CRIT             5min:
   _WINDOWS_MEM_WARN                80
   _WINDOWS_MEM_CRIT                90
   _WINDOWS_ALL_CPU_WARN            80
   _WINDOWS_ALL_CPU_CRIT            90
   _WINDOWS_CPU_WARN                80
   _WINDOWS_CPU_CRIT                90
   _WINDOWS_LOAD_WARN               10
   _WINDOWS_LOAD_CRIT               20
   _WINDOWS_NET_WARN                80
   _WINDOWS_NET_CRIT                90
   _WINDOWS_EXCLUDED_AUTO_SERVICES
   _WINDOWS_AUTO_SERVICES_WARN      0
   _WINDOWS_AUTO_SERVICES_CRIT      1
   _WINDOWS_BIG_PROCESSES_WARN      25

   #Default Network Interface
   _WINDOWS_NETWORK_INTERFACE       Ethernet

   # Now some alert level for a windows host
   _WINDOWS_SHARE_WARN              90
   _WINDOWS_SHARE_CRIT              95

```

To set a specific value for a specific host, declare the same macro in the host definition file.
```
define host{
   use                     generic-host, windows
   contact_groups          admins
   host_name               sim-vm
   address                 192.168.0.16

   poller_tag              site-1

   # Specific values for this host
   # Change warning and critical alerts level for memory
   # Same for CPU, ALL_CPU, DISK, LOAD, NET, ...
   _WINDOWS_MEM_WARN       10
   _WINDOWS_MEM_CRIT       20

   # Exclude some services from automatic start check
   # Use a regexp that matches against the short or long service name as it can be seen in the properties of the service in Windows.
   # The matching services are excluded in the resulting list.
   # Example: (ShortName)|(ShortName)| ... |(ShortName)
   _WINDOWS_EXCLUDED_AUTO_SERVICES (IAStorDataMgrSvc)|(MMCSS)|(ShellHWDetection)|(sppsvc)|(clr_optimization_v4.0.30319_32)
}
```

## Checks examples

```
   /var/lib/shinken/libexec/check_wmi_plus.pl -H localhost -u "DOMAIN\\USER" -p "PASSWORD" -m checkeachcpu -w 80 -c 90 --inidir=/var/lib/shinken/libexec/check_wmi_plus.d
   /var/lib/shinken/libexec/check_wmi_plus.pl -H localhost -u "DOMAIN\\USER" -p "PASSWORD" -m checkad -s replication -w 0 --nodatamode
   /var/lib/shinken/libexec/check_wmi_plus.pl -H localhost -u "DOMAIN\\USER" -p "PASSWORD" -m checkts -s sessions -w 'InactiveSessions=0:1' --inidir=/var/lib/shinken/libexec/check_wmi_plus.d
   /var/lib/shinken/libexec/check_wmi_plus.pl -H localhost -u "DOMAIN\\USER" -p "PASSWORD" -m checkproc -s cpuabove -a '%' -w 25 -exc _AvgCPU=@0:25 --nodataexit 0 --nodatastring "No processes with high CPU found" --inidir=/var/lib/shinken/libexec/check_wmi_plus.d
   /var/lib/shinken/libexec/check_wmi_plus.pl -H localhost -u "DOMAIN\\USER" -p "PASSWORD" -m checkuptime -w '15min:' -c '5min:' --inidir=/var/lib/shinken/libexec/check_wmi_plus.d
   /var/lib/shinken/libexec/check_wmi_plus.pl -H localhost -u "DOMAIN\\USER" -p "PASSWORD" -m checkservice -a Auto -o '' -w 0 -c 1 --inidir=/var/lib/shinken/libexec/check_wmi_plus.d
   /var/lib/shinken/libexec/check_wmi_plus.pl -H localhost -u "DOMAIN\\USER" -p "PASSWORD" -m checkcpuq  -w 10 -c 20 -a 20 -y 0 --inidir=/var/lib/shinken/libexec/check_wmi_plus.d
   /var/lib/shinken/libexec/check_wmi_plus.pl -H localhost -u "DOMAIN\\USER" -p "PASSWORD" -m checkdrivesize -a '.'  -w 90 -c 95 -o 0 -3 1  --inidir=/var/lib/shinken/libexec
   /var/lib/shinken/libexec/check_wmi_plus.pl -H localhost -u "DOMAIN\\USER" -p "PASSWORD" -m checkcpu -w 80 -c 90 --inidir=/var/lib/shinken/libexec/check_wmi_plus.d
   /var/lib/shinken/libexec/check_wmi_plus.pl -H localhost -u "DOMAIN\\USER" -p "PASSWORD" -m checkio -s logical -a '%' --inidir=/var/lib/shinken/libexec/check_wmi_plus.d
   /var/lib/shinken/libexec/check_wmi_plus.pl -H localhost -u "DOMAIN\\USER" -p "PASSWORD" -m checknetwork -w "_ReceiveBytesUtilisation=80" -c "_ReceiveBytesUtilisation=90" -w "_SendBytesUtilisation=80" -c "_SendBytesUtilisation=90" -a "^([0-9A-F]{2}[:-]){5}([0-9A-F]{2})$" --inidir=/var/lib/shinken/libexec/check_wmi_plus.d
   /var/lib/shinken/libexec/check_wmi_plus.pl -H localhost -u "DOMAIN\\USER" -p "PASSWORD" -m checkmem -w 80 -c 90 --inidir=/var/lib/shinken/libexec/check_wmi_plus.d
```
