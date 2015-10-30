# Main server configuration
## OS
```
   root@shinken:~# cat /etc/
   Display all 160 possibilities? (y or n)
   root@shinken:~# cat /etc/*-release
   PRETTY_NAME="Debian GNU/Linux 7 (wheezy)"
   NAME="Debian GNU/Linux"
   VERSION_ID="7"
   VERSION="7 (wheezy)"
   ID=debian
   ANSI_COLOR="1;31"
   HOME_URL="http://www.debian.org/"
   SUPPORT_URL="http://www.debian.org/support/"
   BUG_REPORT_URL="http://bugs.debian.org/"


   root@shinken:~# uname -mrs
   Linux 3.2.0-4-amd64 x86_64
```

## Hostname
```
   root@shinken:~# cat /etc/hostname
   shinken.smbits.com
```

## Network
```
   root@shinken:~# cat /etc/network/interfaces
   # This file describes the network interfaces available on your
   # system and how to activate them. For more information, see
   # interfaces(5).

   # The loopback network interface
   auto lo
   iface lo inet loopback

   # The primary network interface
   auto eth0 eth1
   iface eth0 inet static
           address 159.203.6.148
           netmask 255.255.240.0
           gateway 159.203.0.1
           up ip addr add 10.20.0.5/16 dev eth0
           dns-nameservers 8.8.8.8 8.8.4.4
   iface eth1 inet static
           address 10.137.224.127
           netmask 255.255.0.0
```

## Disks
```
   root@shinken:~# df -h
   Filesystem                 Size  Used Avail Use% Mounted on
   rootfs                      40G  3.0G   35G   8% /
   udev                        10M     0   10M   0% /dev
   tmpfs                      202M  128K  202M   1% /run
   /dev/disk/by-label/DOROOT   40G  3.0G   35G   8% /
   tmpfs                      5.0M     0  5.0M   0% /run/lock
   tmpfs                      403M     0  403M   0% /run/shm
```

## Hardware
```
   root@shinken:~# lshw
   shinken.smbits.com
       description: Computer
       product: Bochs ()
       vendor: Bochs
       width: 64 bits
       capabilities: smbios-2.4 dmi-2.4 vsyscall32
       configuration: boot=normal uuid=D8C6187A-38DE-4163-86E7-64E26F3C071F
     *-core
          description: Motherboard
          physical id: 0
        *-firmware
             description: BIOS
             vendor: Bochs
             physical id: 0
             version: Bochs
             date: 01/01/2011
             size: 96KiB
        *-cpu:0
             description: CPU
             product: Intel(R) Xeon(R) CPU E5-2650L v3 @ 1.80GHz
             vendor: Intel Corp.
             physical id: 401
             bus info: cpu@0
             slot: CPU 1
             size: 2GHz
             capacity: 2GHz
             width: 64 bits
             capabilities: fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx pdpe1gb rdtscp x86-64 constant_tsc arch_perfmon rep_good nopl pni pclmulqdq vmx ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm xsaveopt vnmi ept fsgsbase smep erms
        *-cpu:1
             description: CPU
             product: Intel(R) Xeon(R) CPU E5-2650L v3 @ 1.80GHz
             vendor: Intel Corp.
             physical id: 402
             bus info: cpu@1
             slot: CPU 2
             size: 2GHz
             capacity: 2GHz
             width: 64 bits
             capabilities: fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx pdpe1gb rdtscp x86-64 constant_tsc arch_perfmon rep_good nopl pni pclmulqdq vmx ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm xsaveopt vnmi ept fsgsbase smep erms
        *-memory
             description: System Memory
             physical id: 1000
             size: 2GiB
             capacity: 2GiB
           *-bank
                description: DIMM RAM
                physical id: 0
                slot: DIMM 0
                size: 2GiB
                width: 64 bits
        *-pci
             description: Host bridge
             product: 440FX - 82441FX PMC [Natoma]
             vendor: Intel Corporation
             physical id: 100
             bus info: pci@0000:00:00.0
             version: 02
             width: 32 bits
             clock: 33MHz
           *-isa
                description: ISA bridge
                product: 82371SB PIIX3 ISA [Natoma/Triton II]
                vendor: Intel Corporation
                physical id: 1
                bus info: pci@0000:00:01.0
                version: 00
                width: 32 bits
                clock: 33MHz
                capabilities: isa
                configuration: latency=0
           *-ide
                description: IDE interface
                product: 82371SB PIIX3 IDE [Natoma/Triton II]
                vendor: Intel Corporation
                physical id: 1.1
                bus info: pci@0000:00:01.1
                version: 00
                width: 32 bits
                clock: 33MHz
                capabilities: ide bus_master
                configuration: driver=ata_piix latency=0
                resources: irq:0 ioport:1f0(size=8) ioport:3f6 ioport:170(size=8) ioport:376 ioport:c0c0(size=16)
           *-usb
                description: USB controller
                product: 82371SB PIIX3 USB [Natoma/Triton II]
                description: USB controller
                product: 82371SB PIIX3 USB [Natoma/Triton II]
                vendor: Intel Corporation
                physical id: 1.2
                bus info: pci@0000:00:01.2
                version: 01
                width: 32 bits
                clock: 33MHz
                capabilities: uhci bus_master
                configuration: driver=uhci_hcd latency=0
                resources: irq:11 ioport:c040(size=32)
           *-bridge
                description: Bridge
                product: 82371AB/EB/MB PIIX4 ACPI
                vendor: Intel Corporation
                physical id: 1.3
                bus info: pci@0000:00:01.3
                version: 03
                width: 32 bits
                clock: 33MHz
                capabilities: bridge
                configuration: driver=piix4_smbus latency=0
                resources: irq:9
           *-display UNCLAIMED
                description: VGA compatible controller
                product: GD 5446
                vendor: Cirrus Logic
                physical id: 2
                bus info: pci@0000:00:02.0
                version: 00
                width: 32 bits
                clock: 33MHz
                capabilities: vga_controller
                configuration: latency=0
                resources: memory:fc000000-fdffffff memory:febf0000-febf0fff memory:febe0000-febeffff
           *-network:0
                description: Ethernet controller
                product: Virtio network device
                vendor: Red Hat, Inc
                physical id: 3
                bus info: pci@0000:00:03.0
                version: 00
                width: 32 bits
                clock: 33MHz
                capabilities: msix bus_master cap_list
                configuration: driver=virtio-pci latency=0
                resources: irq:10 ioport:c060(size=32) memory:febf1000-febf1fff
           *-network:1
                description: Ethernet controller
                product: Virtio network device
                vendor: Red Hat, Inc
                physical id: 4
                bus info: pci@0000:00:04.0
                version: 00
                width: 32 bits
                clock: 33MHz
                capabilities: msix bus_master cap_list
                configuration: driver=virtio-pci latency=0
                resources: irq:11 ioport:c080(size=32) memory:febf2000-febf2fff
           *-scsi
                description: SCSI storage controller
                product: Virtio block device
                vendor: Red Hat, Inc
                physical id: 5
                bus info: pci@0000:00:05.0
                version: 00
                width: 32 bits
                clock: 33MHz
                capabilities: scsi msix bus_master cap_list
                configuration: driver=virtio-pci latency=0
                resources: irq:10 ioport:c000(size=64) memory:febf3000-febf3fff
           *-generic
                description: Unclassified device
                product: Virtio memory balloon
                vendor: Red Hat, Inc
                physical id: 6
                bus info: pci@0000:00:06.0
                version: 00
                width: 32 bits
                clock: 33MHz
                capabilities: bus_master
                configuration: driver=virtio-pci latency=0
                resources: irq:11 ioport:c0a0(size=32)
     *-network:0
          description: Ethernet interface
          physical id: 1
          logical name: eth1
          serial: 04:01:81:a9:c5:02
          capabilities: ethernet physical
          configuration: broadcast=yes driver=virtio_net ip=10.137.224.127 link=yes multicast=yes
     *-network:1
          description: Ethernet interface
          physical id: 2
          logical name: eth0
          serial: 04:01:81:a9:c5:01
          capabilities: ethernet physical
          configuration: broadcast=yes driver=virtio_net ip=159.203.6.148 link=yes multicast=yes
```
