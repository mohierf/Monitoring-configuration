# Shinken installation (remote poller)

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

## My specific files ...
```
   su - shinken
   # Fetching doc and extra files
   # Used later in the installation process
   wget https://github.com/mohierf/Monitoring-configuration/archive/master.tar.gz
   tar xvf master.tar.gz
   # cd Monitoring-configuration-master
```

# Shinken modules installation / configuration

## Check Windows servers (WMI checks)
```
   # Install Shinken commands for WMI checks
   su - shinken
   shinken install windows
```

## Check Linux servers (SNMP checks)
```
   # Install Shinken commands for SNMP checks
   su - shinken
   shinken install linux-snmp

   # Update missing plugins
   # !!! Fix Shinken bug !!!
   cp ./Monitoring-configuration-master/plugins/check_netint.pl /var/lib/shinken/libexec/.
   # chown shinken:shinken /var/lib/shinken/libexec/check_netint.pl
   chmod 755 /var/lib/shinken/libexec/check_netint.pl
```


# Shinken distributed configuration

On the main Shinken server, you must:

   1/ set the scheduler master IP address to the server public IP address

   2/ declare a new poller and define its poller tag

On the remote Shinken server, you must:

   3/ set the scheduler master IP address to the main server public IP address

On both servers:

   4/ check that the configuration is correct

   5/ start (or restart) Shinken poller on the remote server

   6/ start (or restart) Shinken on the main server

```
1/
shinken@shinken:/etc/shinken$ vi schedulers/scheduler-master.cfg

      define scheduler {
         scheduler_name      scheduler-master
         address             shinken.smbits.com
         port                7768
         ...


2/
shinken@shinken:/etc/shinken$ cp pollers/poller-master.cfg pollers/poller-remote.cfg
shinken@shinken:/etc/shinken$ vi pollers/poller-remote.cfg


      define poller {
         poller_name       poller-remote
         address           gw-cd.imgnet.com.br
         port              7771
         ...
         poller_tags       Remote


3/
shinken@img-srv-017:~$ vi /etc/shinken/schedulers/scheduler-master.cfg

      define scheduler {
         scheduler_name      scheduler-master ; Just the name
         address             159.203.6.140    ; Main server public IP address
         port                7768             ; TCP port of the daemon
         ...

4/
shinken@shinken:/etc/shinken$ shinken-arbiter -v -c /etc/shinken/shinken.cfg

shinken@img-srv-017:~$ shinken-arbiter -v -c /etc/shinken/shinken.cfg

5/
root@img-srv-017:~# /etc/init.d/shinken-poller start
Starting poller:
. ok

root@img-srv-017:~# tail -n 500 -f /var/log/shinken/pollerd.log

   [1446279000] INFO: [Shinken] Shinken 2.4.2
   [1446279000] INFO: [Shinken] Copyright (c) 2009-2014:
   [1446279000] INFO: [Shinken] Gabes Jean (naparuba@gmail.com)
   [1446279000] INFO: [Shinken] Gerhard Lausser, Gerhard.Lausser@consol.de
   [1446279000] INFO: [Shinken] Gregory Starck, g.starck@gmail.com
   [1446279000] INFO: [Shinken] Hartmut Goebel, h.goebel@goebel-consult.de
   [1446279000] INFO: [Shinken] License: AGPL
   [1446279000] INFO: [Shinken] Trying to initialize additional groups for the daemon
   [1446279000] INFO: [Shinken] Opening HTTP socket at http://0.0.0.0:7771
   [1446279000] INFO: [Shinken] Initializing a CherryPy backend with 8 threads
   [1446279000] INFO: [Shinken] Using the local log file '/var/log/shinken/pollerd.log'
   [1446279000] INFO: [Shinken] Printing stored debug messages prior to our daemonization
   [1446279000] INFO: [Shinken] Successfully changed to workdir: /var/run/shinken
   [1446279000] INFO: [Shinken] Opening pid file: /var/run/shinken/pollerd.pid
   [1446279000] INFO: [Shinken] Redirecting stdout and stderr as necessary..
   [1446279000] INFO: [Shinken] We are now fully daemonized :) pid=18652
   [1446279000] INFO: [Shinken] Starting HTTP daemon
   [1446279001] INFO: [Shinken] Modules directory: /var/lib/shinken/modules
   [1446279001] INFO: [Shinken] Modules directory: /var/lib/shinken/modules
   [1446279001] INFO: [Shinken] Waiting for initial configuration

6/
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


```


