# Checks for switches

## Shinken switch pack
```
   # Install Shinken commands for WMI checks
   su - shinken
   shinken install switch

   # Add a tag to concerned hosts ...
   # vi /etc/shinken/hosts/localhost.cfg
   # => use generic-host, switch       # Set switch template
```

## Install check_nwc_health plugin
```
   su - shinken
   wget https://labs.consol.de/assets/downloads/nagios/check_nwc_health-4.6.1.tar.gz
   tar xvf check_nwc_health-4.6.1.tar.gz
   cd check_nwc_health-4.6.1

   ./configure --prefix=/var/lib/shinken --with-nagios-user=shinken --with-nagios-group=shinken
   make
   make install
   ls -alht /var/lib/shinken/libexec/
   => check_nwc_health
```
