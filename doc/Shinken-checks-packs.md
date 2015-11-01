# Shinken checks packs

## Main Shinken CLI commands
Many checks packs are available on shinken.io packages repository. Shinken has a `shinken` command to manage the packs and plugins.


```
   su - shinken

   # To get online help
   shinken -h
   # Current installed version
   shinken --version
   # List available commands
   shinken --list
   # Get list of installed modules (packs and plugins)
   shinken inventory
```

## Check HTTP/HTTPS
```
   # Install Shinken commands for HTTP/HTTPS checks
   su - shinken
   shinken install htpp

   # For the hosts you want to check that HTTP is available, configure:
   # Web site configuration
   # Set full domain name if not contained in host address property
   _CHECK_HTTP_DOMAIN_NAME         $HOSTADDRESS$
   _CHECK_HTTP_PORT                80
   _CHECK_HTTP_URI                 /
   # Uncomment and set usernmae/password to check HTTP authentication
   _CHECK_HTTP_AUTH                #login:password
```

## Check SMTP
```
   # Install Shinken commands for HTTP/HTTPS checks
   su - shinken
   shinken install htpp
```

## Check DNS
```
   # Install Shinken commands for HTTP/HTTPS checks
   su - shinken
   shinken install htpp

   # For the hosts you want to check that DNS is correctly resolved, configure:
   # Check correct DNS resolution
   _DNSHOSTNAME        $HOSTNAME$
   _DNSEXPECTEDRESULT  $HOSTADDRESS$

```

## Check Windows servers
See [this document](Checks-windows-wmi.md).

## Check Linux servers
See [this document for SNMP checks](Checks-linux-snmp.md) or [this document for NRPE checks](Checks-linux-nrpe.md).

## Check switches
See [this document](Checks-switches.md).

