# Shinken installation

On a fresh Debian 7.9 install:
## Shinken framework
```
   # Logged in as root
   su -

   # Create a Shinken user account
   adduser shinken
   passwd shinken

   # Update server
   apt-get update

   # Python setup tools
   apt-get install python-setuptools python-pip

   # Python utilities
   apt-get install python-pycurl
   apt-get install python-setproctitle

   # Shinken dependencies
   pip install CherryPy
   pip install importlib
   pip install pbr
   pip install html

   # Shinken installation
   pip install shinken
```

## Nagios Plugins
```
   apt-get install nagios-plugins
   apt-get install nagios-nrpe-plugin

   # Avoid errors when launching checks from Shinken ...
   chmod +s /usr/lib/nagios/plugins/*
```

## SNMP agent
```
   # Install local SNMP agent
   su -
   apt-get update
   apt-get install snmpd
   # Not yet! but may be necessary for future monitoring of switches ...
   # apt-get install snmp snmp-mibs-downloader

   # Allow SNMP get
   vi /etc/snmp/snmpd.conf
   =>
      #  Listen for connections from the local system only
      #agentAddress  udp:127.0.0.1:161
      #  Listen for connections on all interfaces (both IPv4 *and* IPv6)
      agentAddress udp:161,udp6:[::1]:161
   =>
      # rocommunity public  default    -V systemonly
      rocommunity public
   # Restart SNMP agent
   /etc/init.d/snmpd restart
```

# Shinken configuration, tips and tricks, ...

## Main Shinken CLI commands
Execute all the commands when logged in with Shinken user account ...

```
   su - shinken

   # Initialize Shinken cLI
   shinken --init
```

```
   # To get online help
   shinken -h
   # Current installed version
   shinken --version
   # List available commands
   shinken --list
   # Get list of installed modules
   shinken inventory

   # Check current configuration - after every configuration change !
   shinken-arbiter -v -c /etc/shinken/shinken.cfg
```

## Shinken / system
```
   # Enable Shinken start at boot
   # NOTE: Not enabled!
   su -
   update-rc.d shinken defaults
```
```
   # Stop / start Shinken
   su -
   # Get status
   /etc/init.d/shinken status
   # Start / stop
   /etc/init.d/shinken start
   /etc/init.d/shinken stop
   # Restart (reload modified configuration)
   /etc/init.d/shinken restart
```
```
   # Check if daemons are running
   curl http://localhost:7768/ # (scheduler)
   curl http://localhost:7769/ # (reactionner)
   curl http://localhost:7770/ # (arbiter)
   curl http://localhost:7771/ # (poller)
   curl http://localhost:7772/ # (broker)
   curl http://localhost:7773/ # (receiver)
```

# Shinken modules installation / configuration

## Shinken remote poller
See [this document](Shinken-poller-installation.md).


## Shinken checks packs
See [this document](Shinken-checks-packs.md).


## Shinken logs
```
   # Install module: simple-log, build a /var/logs/shinken.log file compiling daemons log
   su - shinken
   shinken search log
   shinken install simple-log
   vi /etc/shinken/brokers/broker-master.cfg
   => modules simple-log
```

## Checks state retention
```
   # Install module: pickle-retention-file-scheduler, monitoring objects state retention between Shinken restart
   su - shinken
   shinken search retention
   shinken install pickle-retention-file-scheduler

   # !!! Fix Shinken bug !!!
   vi /var/lib/shinken/modules/pickle-retention-file-scheduler/module.py
   # Comment as is:
   import shinken
   #from shinken.commandcall import CommandCall
   #shinken.objects.command.CommandCall = CommandCall

   # !!! Fix Shinken bug !!!
   vi /etc/shinken/modules/pickle-retention-file-scheduler.cfg
   =>
      define module {
          module_name     pickle-retention-file
          module_type     pickle_retention_file
          path            /var/lib/shinken/retention.dat
      }

   # Add module to scheduler configuration
   vi /etc/shinken/schedulers/scheduler-master.cfg
   => modules pickle-retention-file
   # Retention file is stored in /var/lib/shinken/retention.dat
   # change path in /etc/shinken/modules/pickle-retention-file-scheduler.cfg if needed ...

   # Change/set periodical retention
   vi /etc/shinken/shinken.cfg
   retention_update_interval=15
   # Save every 15 minutes ...
   # Set to 0 to disable retention (not recommanded !)
```

## Web User Interface
```
   # Install module: webui2, Web User Interface
   su - shinken
   shinken search ui
   shinken install webui2
   vi /etc/shinken/brokers/broker-master.cfg
   => modules simple-log, webui2

   # Webui Python dependencies
   su -
   pip install pymongo>=3.0.3 requests arrow bottle==0.12.8

   # Mongodb server (store user's preferences)
   su -
   apt-get install mongodb
   # If not installed:
   # - user's preferences will not persist on Shinken restart
   # - few minutes of unavailability for WebUI after Shinken restart
   # - no system not hosts/services history and availability

   # Configuration
   su - shinken
   vi /etc/shinken/modules/webui2.cfg
   =>
      # Authentication secret for session cookie
      auth_secret       ********


      # WebUI timezone (default is Europe/Paris)
      #timezone                  Europe/Paris
      timezone                  America/Sao_Paulo

```
