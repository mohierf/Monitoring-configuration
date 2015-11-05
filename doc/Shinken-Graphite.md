# Shinken / Graphite

## Metrics organization

   A metric name is built with:
      [_GRAPHITE_PRE.][_GRAPHITE_GROUP.]host_name.[data-source.]service_description.perfdata_name[._GRAPHITE_POST]

   _GRAPHITE_PRE is used as the root hierarchy for the metrics:
      - same value for all hosts
      - proposition: client_name (all the metrics are issued from the client_name infrastructure)

   _GRAPHITE_GROUP is used as a sub-root hierarchy for the metrics
      - value depending upon host type
      - proposition:
         windows, for windows hosts
         linux-snmp, for linux SNMP monitored devices
         linux-nrpe, for linux NRPE monitored devices
         switch, for switches and routers
         san-switch, for SAN switches
         hvb, for UVB hosts

   data-source:
      - same value for all hosts
      - proposition: shinken (all the metrics are issued from Shinken)

   _GRAPHITE_POST is used as a postfix for the metric name
      - not used!

## Metrics typology

### HTTP / HTTPS checks
      Http.size
      Http.time
      Https.size
      Https.time

### DC checks

      client_name.srv-win-001.ADReplications.Number_of_Failed_Replicas

### SAN switches
      client_name.san-switch.san-switch-001.san_switch_sensors._FAN_.3
      client_name.san-switch.san-switch-001.san_switch_sensors._FAN_.2
      client_name.san-switch.san-switch-001.san_switch_sensors._FAN_.1
      client_name.san-switch.san-switch-001.san_switch_sensors.SLOT__0__TEMP_.1
      client_name.san-switch.san-switch-001.san_switch_sensors.SLOT__0__TEMP_.3
      client_name.san-switch.san-switch-001.san_switch_sensors.SLOT__0__TEMP_.2
      client_name.san-switch.san-switch-001.san_switch_sensors._Power_Supply_.1

### Windows hosts

      ; Host check
      client_name.windows.srv-win-01.__HOST__.rta
      client_name.windows.srv-win-01.__HOST__.pl

      ; Uptime
      client_name.windows.srv-win-01.Reboot.Uptime_Minutes

      ; Memory
      client_name.windows.srv-win-01.Memory.Physical_Memory_Utilisation
      client_name.windows.srv-win-01.Memory.Physical_Memory_Used

      ; Network
      ; For each network connection name (Net_connexion_name)
      client_name.windows.srv-win-01.Network_Interface.Net_connexion_name_PacketsReceivedPersec
      client_name.windows.srv-win-01.Network_Interface.Net_connexion_name_OutputQueueLength
      client_name.windows.srv-win-01.Network_Interface.Net_connexion_name_Receive_Utilisation
      client_name.windows.srv-win-01.Network_Interface.Net_connexion_name_PacketsSentPersec
      client_name.windows.srv-win-01.Network_Interface.Net_connexion_name_Send_Utilisation
      client_name.windows.srv-win-01.Network_Interface.Net_connexion_name_BytesSentPersec
      client_name.windows.srv-win-01.Network_Interface.Net_connexion_name_PacketsReceivedErrors
      client_name.windows.srv-win-01.Network_Interface.Net_connexion_name_BytesReceivedPersec

      ; Services
      client_name.windows.srv-win-01.Services.Total_Service_Count
      client_name.windows.srv-win-01.Services.Excluded_Service_Count
      client_name.windows.srv-win-01.Services.Service_Count_Problem_State
      client_name.windows.srv-win-01.Services.Service_Count_OK_State

      ; Load
      client_name.windows.srv-win-01.LoadAverage.Avg_CPU_Queue_Length

      ; Cpu
      client_name.windows.srv-win-01.Cpu.Avg_CPU_Utilisation

      ; Each Cpu
      ; Overall ...
      client_name.windows.srv-win-01.EachCpu.Avg_Utilisation_CPU_Total
      ; For each CPU ...
      client_name.windows.srv-win-01.EachCpu.Avg_Utilisation_CPU0
      client_name.windows.srv-win-01.EachCpu.Avg_Utilisation_CPU1
      client_name.windows.srv-win-01.EachCpu.Avg_Utilisation_CPU2
      client_name.windows.srv-win-01.EachCpu.Avg_Utilisation_CPU3

      ; Disk
      ; Overall ...
      client_name.windows.srv-win-01.Disks.Overall_Disk_Space
      client_name.windows.srv-win-01.Disks.Overall_Disk_Utilisation
      ; For each disk ...
      client_name.windows.srv-win-01.Disks.C__Utilisation
      client_name.windows.srv-win-01.Disks.C__Space

      ; Disks I/O
      client_name.windows.srv-win-01.DisksIO.CurrentDiskQueueLengthHarddiskVolume1 0 1446602424
      client_name.windows.srv-win-01.DisksIO.CurrentDiskQueueLengthC_ 0 1446602424
      client_name.windows.srv-win-01.DisksIO.CurrentDiskQueueLength_Total 0 1446602424

      client_name.windows.srv-win-01.DisksIO._AvgDiskQueueLengthHarddiskVolume1
      client_name.windows.srv-win-01.DisksIO._AvgDiskReadQueueLengthHarddiskVolume1
      client_name.windows.srv-win-01.DisksIO._AvgDiskWriteQueueLengthHarddiskVolume1 0 1446602424

      client_name.windows.srv-win-01.DisksIO._PercentDiskReadTimeHarddiskVolume1
      client_name.windows.srv-win-01.DisksIO._PercentIdleTimeHarddiskVolume1
      client_name.windows.srv-win-01.DisksIO._PercentBusyTimeHarddiskVolume1 0 1446602424
      client_name.windows.srv-win-01.DisksIO._PercentDiskTimeHarddiskVolume1 0 1446602424
      client_name.windows.srv-win-01.DisksIO._PercentDiskWriteTimeHarddiskVolume1 0 1446602424

      client_name.windows.srv-win-01.DisksIO._DiskWritesPersecHarddiskVolume1 0 1446602424
      client_name.windows.srv-win-01.DisksIO._DiskReadsPersecHarddiskVolume1 0 1446602424

      client_name.windows.srv-win-01.DisksIO._DiskReadBytesPersecHarddiskVolume1 0 1446602424
      client_name.windows.srv-win-01.DisksIO._DiskWriteBytesPersecHarddiskVolume1

      client_name.windows.srv-win-01.DisksIO._AvgDiskReadQueueLength_Total 0 1446602424
      client_name.windows.srv-win-01.DisksIO._AvgDiskWriteQueueLength_Total 0 1446602424
      client_name.windows.srv-win-01.DisksIO._AvgDiskReadQueueLengthC_ 0 1446602424
      client_name.windows.srv-win-01.DisksIO._AvgDiskWriteQueueLengthC_ 0 1446602424

      client_name.windows.srv-win-01.DisksIO._DiskReadsPersec_Total 1 1446602424
      client_name.windows.srv-win-01.DisksIO._DiskWritesPersec_Total 3 1446602424
      client_name.windows.srv-win-01.DisksIO._DiskReadsPersecC_ 1 1446602424
      client_name.windows.srv-win-01.DisksIO._DiskWriteBytesPersecC_ 60294 1446602424

      client_name.windows.srv-win-01.DisksIO._PercentDiskTimeC_ 3 1446602424
      client_name.windows.srv-win-01.DisksIO._PercentDiskTime_Total 1 1446602424
      client_name.windows.srv-win-01.DisksIO._PercentDiskReadTimeC_ 3 1446602424
      client_name.windows.srv-win-01.DisksIO._PercentDiskReadTime_Total 1 1446602424
      client_name.windows.srv-win-01.DisksIO._PercentDiskWriteTimeC_ 0 1446602424
      client_name.windows.srv-win-01.DisksIO._PercentDiskWriteTime_Total 0 1446602424
      client_name.windows.srv-win-01.DisksIO._PercentIdleTimeC_ 99 1446602424
      client_name.windows.srv-win-01.DisksIO._PercentIdleTime_Total 100 1446602424
      client_name.windows.srv-win-01.DisksIO._PercentBusyTimeC_ 1 1446602424
      client_name.windows.srv-win-01.DisksIO._PercentBusyTime_Total 0 1446602424
      client_name.windows.srv-win-01.DisksIO._DiskReadBytesPersec_Total 4254 1446602424
      client_name.windows.srv-win-01.DisksIO._DiskWritesPersecC_ 3 1446602424
      client_name.windows.srv-win-01.DisksIO._AvgDiskQueueLength_Total 0 1446602424
      client_name.windows.srv-win-01.DisksIO._AvgDiskQueueLengthC_ 0 1446602424
      client_name.windows.srv-win-01.DisksIO._DiskWriteBytesPersec_Total 60294 1446602424
      client_name.windows.srv-win-01.DisksIO._DiskReadBytesPersecC_ 4254 1446602424

### Linux SNMP hosts

      ; Host check
      client_name.linux-snmp.srv-snmp-001.__HOST__.rta
      client_name.linux-snmp.srv-snmp-001.__HOST__.pl

      ; Memory
      client_name.linux-snmp.srv-snmp-001.Memory.ram_free
      client_name.linux-snmp.srv-snmp-001.Memory.ram_buffered
      client_name.linux-snmp.srv-snmp-001.Memory.ram_cached
      client_name.linux-snmp.srv-snmp-001.Memory.ram_total

      ; Network
      ; For each interface
      client_name.linux-snmp.srv-snmp-001.NetworkUsage.eth0_in_error
      client_name.linux-snmp.srv-snmp-001.NetworkUsage.eth0_out_error
      client_name.linux-snmp.srv-snmp-001.NetworkUsage.eth0_in_discard
      client_name.linux-snmp.srv-snmp-001.NetworkUsage.eth0_out_prct
      client_name.linux-snmp.srv-snmp-001.NetworkUsage.eth0_out_discard
      client_name.linux-snmp.srv-snmp-001.NetworkUsage.eth0_in_prct

      ; Load
      client_name.linux-snmp.srv-snmp-001.Load.load_5_min
      client_name.linux-snmp.srv-snmp-001.Load.load_15_min
      client_name.linux-snmp.srv-snmp-001.Load.load_1_min

      ; Cpu
      client_name.linux-snmp.srv-snmp-001.Cpu.cpu_prct_used

      ; Disks
      client_name.linux-snmp.srv-snmp-001.Disks._
      client_name.linux-snmp.srv-snmp-001.Disks._dev
      client_name.linux-snmp.srv-snmp-001.Disks._boot

      ; NTP time syn
      client_name.linux-snmp.srv-snmp-001.TimeSync.offset

### Linux NRPE hosts

      ; Host check
      client_name.linux-nrpe.srv-nrpe-001.__HOST__.rta 1.089 1446602431
      client_name.linux-nrpe.srv-nrpe-001.__HOST__.pl 0 1446602431

      ; Memory
      client_name.linux-nrpe.srv-nrpe-001.nrpe-Memory.ram_free
      client_name.linux-nrpe.srv-nrpe-001.nrpe-Memory.ram_buffered
      client_name.linux-nrpe.srv-nrpe-001.nrpe-Memory.ram_cached
      client_name.linux-nrpe.srv-nrpe-001.nrpe-Memory.ram_total

      ; Network
      ; For each interface
      client_name.linux-nrpe.srv-nrpe-001.NetworkUsage.eth0_in_error
      client_name.linux-nrpe.srv-nrpe-001.NetworkUsage.eth0_out_error
      client_name.linux-nrpe.srv-nrpe-001.NetworkUsage.eth0_in_discard
      client_name.linux-nrpe.srv-nrpe-001.NetworkUsage.eth0_out_prct
      client_name.linux-nrpe.srv-nrpe-001.NetworkUsage.eth0_out_discard
      client_name.linux-nrpe.srv-nrpe-001.NetworkUsage.eth0_in_prct

      ; Load
      client_name.linux-nrpe.srv-nrpe-001.nrpe-Load.load1 0.09 1446602546
      client_name.linux-nrpe.srv-nrpe-001.nrpe-Load.load15 0.07 1446602546
      client_name.linux-nrpe.srv-nrpe-001.nrpe-Load.load5 0.1 1446602546

      ; Users
      client_name.linux-nrpe.srv-nrpe-001.nrpe-Users.users 0 1446602679

      ; Cpu
      client_name.linux-nrpe.srv-nrpe-001.nrpe-Cpu.cpu_prct_used

      ; Disks
      client_name.linux-nrpe.srv-nrpe-001.nrpe-Disk-hda1._

## Feeding Graphite with some data

The Graphite broker module is listening to all the hosts and services checks to fetch performance data from the checks results and send the performance data as metrics to Graphite.

### Graphite2 broker module
It exists two versions of the Graphite broker module:

   - the first version `graphite` is quite an old version still compatible with Shinken 1.4.
   - the second version, no more compatible with Shinken 1.4, and fully tested with the new Web UI

This recent version has rich features, such as:

   - do not manage metrics until initial hosts/services status are received
      This to avoid feeding Graphite with metrics without their prefixes/postfixes which are defined in hosts and services configuration.

   - maintain a cache for the packets not sent because of connection problems
      When connection is restored, the cached packets are sent to Carbon/Graphite.
      Cache size and cached packets burst volume are configurable.

   - metrics threshold filtering
      Allows to define if warning/critical, min/max metrics thresholds are to be sent to Carbon/Graphite.
      This to allow storing 4 extra metrics for each performance data. Theresholds can be defined as fixed lines in the graphs and it is not necessary to send those fixed values to Carbon/Graphite.

   - metrics filtering
      Allows to define for a service_description which performance data will not be sent to Carbon/Graphite
      As an example, for a `Load` service, you may filter `1m` and `15m` and send only the `5m` performance data value.

   - define a specific data source for Shinken
      If you have several applications feeding Graphite, you can define a specific data source for Shinken sent metrics.

   - manage hosts and services custom variables
      Host variable _GRAPHITE_PRE is used as the root hierarchy for the metric name
      Host variable _GRAPHITE_GROUP is used as a sub-root hierarchy for the metric name
      Service variable _GRAPHITE_POST is used as a postfix for the metric name
      A metric name is built with:
         [_GRAPHITE_PRE.][_GRAPHITE_GROUP.]host_name.[data-source.]service_description.perfdata_name[._GRAPHITE_POST]

The module configuration is heavily documented to use the configuration parameters.

```
   # Installing forked mod-graphite
   su - shinken
   shinken install graphite2

   # Declare broker module
   vi /etc/shinken/brokers/broker-master.cfg
   => modules webui2, graphite2

   # Configure module
   vi /etc/shinken/modules/graphite2.cfg
   =>
      # Set Graphite host address
      host   graphite

   =>
      # Set Shinken data source
      graphite_data_source   shinken

   => Specify filters:
      # This configuration allow to filter all the metrics of all the default defined services
      # The only metrics sent to Carbon/Graphite are hosts checks metrics (ping rta and pl)
      # Http / Https
      filter Http:
      filter Https:

      # Windows WMI
      filter Reboot:
      filter Memory:
      filter Services:
      filter Network Interface:
      filter LoadAverage:
      filter Cpu:
      filter EachCpu:
      filter Disks:
      filter DisksIO:
      filter InactiveSessions:
      filter BigProcesses:

      # Linux SNMP
      filter Memory:
      filter Load:
      filter NetworkUsage:
      filter Cpu:
      filter Disks:
      filter TimeSync:

      # Linux NRPE
      filter nrpe-Memory:
      filter nrpe-NetworkUsage:
      filter nrpe-Load:
      filter nrpe-Cpu:
      filter nrpe-Disk-hda1:
      filter nrpe-Users:
      filter nrpe-Procs:
      filter nrpe-Zombies:


      # Switches
      filter Network Interface:

```

### Graphite module configuration
When using the Hosted Graphite service, the usual configuration is to be adapted.

The Graphite server address is the endpoint address of the Hosted Graphite account.
The hosts must be prefixed with the Hosted Graphite API key.

```
   # Configure module
   vi /etc/shinken/modules/graphite2.cfg
   =>
      # Set hostedgraphite.com endpoint adress as Graphite host
      host   01234567.carbon.hostedgraphite.com
```

We must used the `_GRAPHITE_PRE` custom variables to declare the Hosted Graphite API Key.
As we are interested by the metrics of all the monitored hosts, the best solution is to set the `_GRAPHITE_PRE` in the `generic-host` template ... all the hosts will inherit this prefix.

```
   # Configure the hosts to be considered
   vi /etc/shinken/templates/generic-host.cfg
   =>
      define host{
              name                            generic-host

              # Use Graphite prefix feature for Hosted Graphite API key
              _GRAPHITE_PRE                   a607e7fe-d2e8-40bd-9cf4-24652f4b1f9d

```

## Viewing data from Graphite

The Web UI Graphite module is using the Graphite graphs rendering API to display graphs in the Shinken Web UI.

### Graphite Web UI module
It exists two versions of the Graphite broker module:

   - the first version `ui-graphite` is quite an old version still compatible with Shinken 1.4.
   - the second version, no more compatible with Shinken 1.4, and fully tested with the new Web UI

This recent version has rich features, such as:

   - define graph and font size for dashboard and element page graphs
      The space allowed for the graphs is limited in the Dashboard view. As of it it is possible to define the size of the graphs and of the font used in the graphs.

   - metrics threshold filtering
      Allows to define if warning/critical, min/max thresholds are present in the graphs. And if so, which color is to be used for each one of them.

   - metrics filtering
      Allows to define for a service_description which performance data will not be sent to Carbon/Graphite
      As an example, for a `Load` service, you may filter `1m` and `15m` and send only the `5m` performance data value.

   - define the graphs line mode
      `connected` (default) for a line connecting the points
      `slope`
      `staircase`
      Test the modes to see which one looks better to your metrics ...

   - define the graphs Time Zone
      Defaults to `Europe/Paris` to request to Graphite for this time zone in the provided graphs.

The module configuration is heavily documented to use the configuration parameters.

```
   su - shinken

   # Installing official mod-ui-graphite (to get the templates ...)
   shinken install ui-graphite2

   # Declare Web UI module
   vi /etc/shinken/modules/webui2.cfg
   => modules ui-graphite2

   # Configure module
   vi /etc/shinken/modules/ui-graphite2.cfg
   =>
      # Set Graphite host address
      uri   http://graphite/
   =>
      # Set Shinken data source
      graphite_data_source   shinken
```

