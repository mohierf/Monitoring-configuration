On a fresh Debian 7.9 install:

Install Shinken
=================
   su -
   adduser shinken
   passwd shinken

   # Python setup tools
   apt-get install python-setuptools python-pip
   apt-get install python-pycurl
   apt-get install python-setproctitle

   # Shinken dependencies
   pip install CherryPy
   pip install importlib
   pip install pbr
   pip install html

   # Shinken installation
   pip install shinken

   # Nagios Plugins
   apt-get install nagios-plugins
   # Avoid errors when launching checks from Shinken ...
   chmod +s /usr/lib/nagios/plugins/*

   # Install local SNMP agent
   su -
   apt-get install snmpd

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

Configure Shinken
=================
   Main Shinken CLI commands
   -------------------------
   su - shinken
   shinken --init
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

   Shinken / system
   -------------------------
   # Enable Shinken start at boot
   su -
   update-rc.d shinken defaults

   # Stop / start Shinken
   su -
   /etc/init.d/shinken start
   /etc/init.d/shinken stop
   /etc/init.d/shinken restart

   # Check if daemons are running
   curl http://localhost:7768/ # (scheduler)
   curl http://localhost:7769/ # (reactionner)
   curl http://localhost:7770/ # (arbiter)
   curl http://localhost:7771/ # (poller)
   curl http://localhost:7772/ # (broker)
   curl http://localhost:7773/ # (receiver)

Shinken modules
=================
   Check Windows servers
   -------------------------
   # Install Shinken commands for WMI checks
   su - shinken
   shinken install windows

   Check Linux servers
   -------------------------
   # Install Shinken commands for SNMP checks
   su - shinken
   shinken install linux-snmp
   vi /etc/shinken/hosts/localhost.cfg
   => host_name Shinken                # Set server hostname
   => use generic-host, linux-snmp     # Set server templates

   # Fix missing perl dependency when checks are launched from Shinken directory
   # !!! Fix Shinken bug !!!
   # NOTE: Run this command only if you did not installed WMI module!
   ln -s /usr/lib/nagios/plugins/utils.pm /var/lib/shinken/libexec/utils.pm

   Shinken logs
   -------------------------
   # Install module: simple-log, build a /var/logs/shinken.log file compiling daemons log
   su - shinken
   shinken search log
   shinken install simple-log
   vi /etc/shinken/brokers/broker-master.cfg
   => modules simple-log

   Checks state retention
   -------------------------
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

   Web User Interface
   -------------------------
   # Install module: webui2, Web User Interface
   su - shinken
   shinken search ui
   shinken install webui2
   vi /etc/shinken/brokers/broker-master.cfg
   => modules simple-log, webui2

   # Webui Python dependencies
   su -
   pip install pymongo>=3.0.3 requests arrow bottle==0.12.8

   # Mongodb server
   su -
   apt-get install mongodb