# Shinken / Graphite

## My own refactored branch in the official repo ...
This branch makes some optimizations in the Graphite metrics sent from Shinken and it allows to have some filtering in the metrics sent!
```
   # Installing forked mod-graphite
   su - shinken
   wget https://github.com/shinken-monitoring/mod-graphite/archive/refactored.tar.gz
   tar xvf refactored.tar.gz
   # Install module
   mkdir /var/lib/shinken/modules/graphite
   cp mod-graphite-refactored/module/* /var/lib/shinken/modules/graphite/
   # Install module configuration
   cp mod-graphite-refactored/etc/modules/graphite.cfg /etc/shinken/modules/graphite.cfg

   # Declare broker module
   vi /etc/shinken/brokers/broker-master.cfg
   => modules webui2, graphite

   # Configure module
   vi /etc/shinken/modules/graphite.cfg
   =>
      # Set Graphite host address
      host   graphite

   => graphite_data_source   ...
```

## Graphite module configuration
When using the Hosted Graphite service, the usual configuration is to be adapted.

The Graphite server address is the endpoint address of the Hosted Graphite account. The hosts must be prefixed with the Hosted Graphite API key.

```
   # Configure module
   vi /etc/shinken/modules/graphite.cfg
   =>
      # Set hostedgraphite.com endpoint adress as Graphite host
      host   02bb6f15.carbon.hostedgraphite.com

   => graphite_data_source   ...
```

As we are interested by the metrics of all the monitored hosts, the best solution is to set the Graphite prefix in the `generic-host` template ... all the hosts will inherit this prefix.

```
   # Configure the hosts to be considered
   vi /etc/shinken/templates/generic-host.cfg
   =>
      define host{
              name                            generic-host

              # Use Graphite prefix feature for Hosted Graphite API key
              _GRAPHITE_PRE                   a607e7fe-d2e8-40bd-9cf4-24652f4b1f9d

```

```
## Module:      graphite
## Loaded by:   Broker
# Export host and service performance data to Graphite carbon process.
# Graphite is a time series database with a rich web service interface, viewed
# as a modern alternative to RRDtool.  http://graphite.wikidot.com/start
define module {
   module_name     graphite
   module_type     graphite_perfdata

   # Graphite server / port to use
   # default to localhost:2003
   host            02bb6f15.carbon.hostedgraphite.com
   port            2003

   # Optionally specify a source identifier for the metric data sent to
   # Graphite. This can help differentiate data from multiple sources for the
   # same hosts.
   #
   # Result is:
   # host.GRAPHITE_DATA_SOURCE.service.metric
   # instead of:
   # host.service.metric
   #
   # Note: You must set the same value in this module and in the
   # Graphite UI moduleconfiguration.
   #
   # default: the variable is unset
   #graphite_data_source shinken

   # Optionnaly specify a latency management
   # If this parameter is enabled the metric time will be change to remove latency
   # For example if the check was scheduled at 0 but was done at 2,
   # the timestamp associated to the data will be 0
   # Basically this ignore small latency in order to have regular interval between data.
   # We skip an Graphite limitation that expect a specific timestamp range for data.
   #ignore_latency_limit 15

   # Optionnaly specify a service description for host check metrics
   #
   # Graphite stores host check metrics in the host directory whereas services
   # are stored in host.service directory. Host check metrics may be stored in their own
   # directory if it is specified.
   #
   # default: __HOST__
   hostcheck           __HOST__

   # Optionnaly specify filtered metrics
   # Filtered metrics will not be sent to Carbon/Graphite
   #
   # Declare a filter parameter for each service to be filtered:
   # filter    service_description:metrics
   #
   # metrics is a comma separated list of the metrics to be filtered
   # default: no filtered metrics
   #filter           cpu:1m,5m
   #filter           mem:3z

   # Optionnaly specify extra metrics
   # warning, critical, min and max information for the metrics are not often necessary
   # in Graphite
   # You may specify which one are to be sent or not
   # Default is not to send anything else than the metric value
   #send_warning      False
   #send_critical     False
   #send_min          False
   #send_max          False
}
```
