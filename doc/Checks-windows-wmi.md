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


## Checks examples

   First line: launched command
   Second line: check output
   Third line: performance data

