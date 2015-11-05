# Graphite installation

On a fresh Ubuntu 14.04 install:

## Set up components
```
   # Logged in as root

   # Update server
   apt-get update

   # Set server timezone as UTC
   dpkg-reconfigure tzdata
   => Choose UTC

   # Graphite Carbon / Graphite Web
   apt-get install graphite-web graphite-carbon
```

### Graphite Web Application

The Graphite Web application is not used to build dashboards whereas it is dashboards capable, but choosing Grafana as a dashboards tool is a good choice.

Graphite Web application is useful to create some events in the Django backend because those events will be displayed on the graphs ...

```
   # Install a database for Django backend
   apt-get install postgresql libpq-dev python-psycopg2

   # Create a Database User and a Database
   sudo -u postgres psql

   postgres =# CREATE USER graphite WITH PASSWORD 'graphite';
   postgres =# CREATE DATABASE graphite WITH OWNER graphite;
   postgres =# \q

   # Configure Graphite Web Application
   vi /etc/graphite/local_settings.py
      # Change the default secret key ...
      => SECRET_KEY = 'changed'
      # Change the default Time Zone (set to your time zone)
      => TIME_ZONE = 'America/New_York'
      # Remote user authentication
      => USE_REMOTE_USER_AUTHENTICATION = True
      # Configure the database access
      DATABASES = {
         'default': {
            'NAME': 'graphite',
            'ENGINE': 'django.db.backends.postgresql_psycopg2',
            'USER': 'graphite',
            'PASSWORD': 'graphite',
            'HOST': '127.0.0.1',
            'PORT': ''
         }
      }
   # Save the file

   # Sync the Database
   graphite-manage syncdb
   # Create a super user account
   => login / password / mail

   # Install Apache
   apt-get install apache2 libapache2-mod-wsgi

   # Disable default site and replace with Graphite
   a2dissite 000-default
   cp /usr/share/graphite-web/apache2-graphite.conf /etc/apache2/sites-available
   a2ensite apache2-graphite
   service apache2 reload

   # Navigate to server / Graphite Web application
   http://myserver.com
   # More on Graphite Web application on: http://graphite.readthedocs.org/en/latest/index.html

```

### Carbon metrics collector

Carbon is the most important element because it is the daemon that collects all the metrics and store them in Whisper files.

```
   # Configure Carbon
   vi /etc/default/graphite-carbon
   # Enable carbon service on boot
   => CARBON_CACHE_ENABLED=true

   # Configuration file
   vi /etc/carbon/carbon.conf
   # Enable log rotation
   => ENABLE_LOGROTATION = True

   # Configure storage schemas
   vi /etc/carbon/storage-schemas.conf

      # Schema definitions for Whisper files. Entries are scanned in order,
      # and first match wins. This file is scanned for changes every 60 seconds.
      #
      #  [name]
      #  pattern = regex
      #  retentions = timePerPoint:timeToStore, timePerPoint:timeToStore, ...

      # Carbon's internal metrics. This entry should match what is specified in
      # CARBON_METRIC_PREFIX and CARBON_METRIC_INTERVAL settings
      [carbon]
      pattern = ^carbon\.
      retentions = 60:90d

      [statsd]
      pattern = ^stats.*
      retentions = 1m:4h,5m:1w,30m:30d,1h:1y

      [default]
      pattern = ^shinken\.
      # 1m bucket for 4h
      # 5m bucket for one week
      # 30m bucket for 30 days
      # 1h bucket for one year
      retentions = 1m:4h,5m:1w,30m:30d,1h:1y

   # Configure storage aggregation
   cp /usr/share/doc/graphite-carbon/examples/storage-aggregation.conf.example /etc/carbon/storage-aggregation.conf
   vi /etc/carbon/storage-aggregation.conf

   ### Beware of the default xFilesFactor (0.5) parameter ... else aggregation will not be made for metrics sent !

      # Aggregation methods for whisper files. Entries are scanned in order,
      # and first match wins. This file is scanned for changes every 60 seconds
      #
      #  [name]
      #  pattern = <regex>
      #  xFilesFactor = <float between 0 and 1>
      #  aggregationMethod = <average|sum|last|max|min>
      #
      #  name: Arbitrary unique name for the rule
      #  pattern: Regex pattern to match against the metric name
      #  xFilesFactor: Ratio of valid data points required for aggregation to the next retention to occur
      #  aggregationMethod: function to apply to data points for aggregation
      #
      [min]
      pattern = \.min$
      xFilesFactor = 0.1
      aggregationMethod = min

      [max]
      pattern = \.max$
      xFilesFactor = 0.1
      aggregationMethod = max

      [count]
      pattern = \.count$
      xFilesFactor = 0
      aggregationMethod = sum

      [lower]
      pattern = \.lower(_\d+)?$
      xFilesFactor = 0.1
      aggregationMethod = min

      [upper]
      pattern = \.upper(_\d+)?$
      xFilesFactor = 0.1
      aggregationMethod = max

      [sum]
      pattern = \.sum$
      xFilesFactor = 0
      aggregationMethod = sum

      [gauges]
      pattern = ^.*\.gauges\..*
      xFilesFactor = 0
      aggregationMethod = last

      [default_average]
      pattern = .*
      xFilesFactor = 0
      aggregationMethod = average

   # Start the metrics collector
   service carbon-cache start

   # Carbon logs
   cat /var/log/carbon/console.log
      05/11/2015 05:06:27 :: Log opened.
      05/11/2015 05:06:27 :: twistd 13.2.0 (/usr/bin/python 2.7.6) starting up.
      05/11/2015 05:06:27 :: reactor class: twisted.internet.epollreactor.EPollReactor.
      05/11/2015 05:06:27 :: ServerFactory starting on 2003
      05/11/2015 05:06:27 :: Starting factory <twisted.internet.protocol.ServerFactory instance at 0x7fdb05900fc8>
      05/11/2015 05:06:27 :: ServerFactory starting on 2004
      05/11/2015 05:06:27 :: Starting factory <twisted.internet.protocol.ServerFactory instance at 0x7fdb058fd1b8>
      05/11/2015 05:06:27 :: ServerFactory starting on 7002
      05/11/2015 05:06:27 :: Starting factory <twisted.internet.protocol.ServerFactory instance at 0x7fdb058fd3f8>
      05/11/2015 05:06:27 :: set uid/gid 106/114

   # Test carbon (send a metric test.count)
   echo "test.count 4 `date +%s`" | nc -q0 127.0.0.1 2003

   ##Very first metric sent to Carbon!

   # Carbon logs
   cat /var/log/carbon/creates.log
      05/11/2015 05:19:46 :: new metric test.count matched schema default
      05/11/2015 05:19:46 :: new metric test.count matched aggregation schema count
      05/11/2015 05:19:46 :: creating database file /var/lib/graphite/whisper/test/count.wsp (archive=[(60, 10080)] xff=0.0 agg=sum)

   cat /var/log/carbon/listener.log
      05/11/2015 05:19:46 :: MetricLineReceiver connection with 127.0.0.1:43773 established
      05/11/2015 05:19:46 :: MetricLineReceiver connection with 127.0.0.1:43773 closed cleanly

```

### StatsD metrics collector

StatsD flushes stats to Carbon/Graphite in sync with Graphite's configured write interval.
To do this, it aggregates all of the data between flush intervals and creates single points for each statistic to send to Graphite.

**Currently** not installed on the server, but:

 - StatsD will allow to get Shinken own internal metrics ...
 - no StatsD module exist officially on Shinken, but I developed a prototype not yet production ready!

```

```

### Grafana dashboard application

```
   # Add APT source
   vi /etc/apt/sources.list
   => Add this line to end of file
      deb https://packagecloud.io/grafana/stable/debian/ wheezy main

   # Add the key
   curl https://packagecloud.io/gpg.key | apt-key add -
   apt-get update

   # Install Grafana
   apt-get install grafana

   # Configure the Grafana server to start at boot time
   update-rc.d grafana-server defaults 95 10

   # Create a Database User and a Database
   sudo -u postgres psql

   postgres =# CREATE USER grafana WITH PASSWORD 'grafana';
   postgres =# CREATE DATABASE grafana WITH OWNER grafana;
   postgres =# \q

   # Configure Grafana to use Postgres database
   vi /etc/grafana/grafana.ini
   => Changed sections:
      [database]
      type = postgres
      host = 127.0.0.1:5432
      name = grafana
      user = grafana
      password = grafana

      # For "postgres" only, either "disable", "require" or "verify-full"
      ssl_mode = disable

      [security]
      # default admin user, created on startup
      admin_user = changed

      # default admin password, can be changed before first start of grafana,  or in profile settings
      admin_password = changed

      # used for signing
      secret_key = Changed_also!

      [users]
      # disable user signup / registration
      allow_sign_up = false

      # Allow non admin users to create organizations
      allow_org_create = false

   # Start Grafana server
   service grafana-server start

   # Navigate to server / Grafana
   http://myserver.com:3000
   # More on Grafana application on: http://docs.grafana.org/
```

### Configuring and using Grafana dashboards

   1/ add a datasource for the Graphite application:
      - name Graphite, use as default datasource
      - url: http://127.0.0.1:80, proxy access

   2/ create a test dashboard
      - menu Dashboard, button New, then Settings  (cog icon)
      - name Test, tags 'test'
      - add a Graph panel, with the metric test.count
      - add a Single stat panel, with the metric test.count

   3/ Feed Carbon/Graphite with some values
   ```
      echo "test.count 5 `date +%s`" | nc -q0 127.0.0.1 2003
      echo "test.count 3 `date +%s`" | nc -q0 127.0.0.1 2003
      echo "test.count 6 `date +%s`" | nc -q0 127.0.0.1 2003
      echo "test.count 10 `date +%s`" | nc -q0 127.0.0.1 2003
   ```

   4/ From the main Shinken server, also ...
   ```
      echo "test.count 15 `date +%s`" | nc -q0 192.168.0.42 2003
   ```

   5/ check in the test dashboard that the data are present ...