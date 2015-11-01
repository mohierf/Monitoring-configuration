# Shinken configuration

The Shinken configuration files are located in `/etc/shinken` directory.

Note: All the files creation and modification should be made when lloged in with the `shinken` user.

## Shinken main configuration file

The main interesting part of this file are documented hereunder

```
shinken@shinken:~$ vi /etc/shinken/shinken.cfg

   ...
   # Fred: default is 60 minutes, it is better every 15 minutes
   # Number of minutes between 2 retention save, here 1hour
   retention_update_interval=60

   ...
   # Fred: unnecessary and noisy when checking configuration.
   # if 1, disable all notice and warning messages at
   # configuration checking
   disable_old_nagios_parameters_whining=1

```

## Main server configuration
Main server is monitored using SNMP checks.

```
shinken@shinken:~$ vi /etc/shinken/hosts/localhost.cfg

   define host{
           use                     generic-host, linux-snmp, important
           contact_groups          admins
           host_name               shinken
           alias                   Shinken
           display_name            SMBits Shinken monitoring server
           address                 127.0.0.1
           }
```

## Contacts

By default, I configured two contacts (admin and guest) and two contacts groups (admins and guests).

**Note**: the contact password defined in the password property is only to be used for Web UI login. You should chnage this password.

### Defined contacts
```
shinken@shinken:~$ vi /etc/shinken/contacts/admin.cfg

   # Administrator
   # Fred: Change its password ...
   define contact{
      use                 generic-contact
      contact_name        admin
      alias               Big brother
      email               shinken@localhost
      pager               0600000000   ; contact phone number
      password            **********
      is_admin            1
      expert              1
   }
```

```
shinken@shinken:~$ vi /etc/shinken/contacts/guest.cfg

   # Guest user
   # Fred: Change its password or remove this contact ...
   define contact{
      use                 generic-contact
      contact_name        guest
      alias               Guest
      email               guest@localhost
      password            ********
      can_submit_commands 0
   }

```

### Defined contacts groups

To add a contact to a contacts groups, simply add its `contact_name` to the members property of the group.

```
shinken@shinken:~$ vi /etc/shinken/contactgroups/admins.cfg

define contactgroup{
   contactgroup_name   admins
   alias               Administrators
   members             admin
}
```

## Business impact

Business impact defines an importance level for host or service. From 0 (not important) to 5 (top for business).

An host can be affected a business impact in two ways:

- business_impact property, valued from 0 to 5
- use a predefined tag (preferred way): no-importance, qualification, production, important, top-for-business

Set the BI tag in the host `use` list property to affect a business impact to an host.

```
shinken@shinken:~$ vi /etc/shinken/templates/business-impact.cfg


# Some business impact templates. The default value for
# business impact is 2, mean "ok it's prod". 1 means, low
# 0 mean none. For top value, the higher the most important ;)
define host{
       name             qualification
       register         0
       business_impact  1
}

# 0 is for no importance at all, and no notification
define host{
       name                     no-importance
       register                 0
       business_impact          0
       notifications_enabled    0
}

# Ok we start to be important
define host{
       name             production
       register         0
       business_impact  3
}


# It began to be very  important
define host{
       name             important
       register         0
       business_impact  4
}


# TOP FOR BUSINESS!
define host{
       name             top-for-business
       register         0
       business_impact  5
}


# Some business impact templates. The default value for
# business impact is 2, mean "ok it's prod". 1 means, low
# 0 mean none. For top value, the higher the most important ;)
define service{
       name             qualification
       register         0
       business_impact  1
}

# 0 is for no importance at all, and no notification
define service{
       name                     no-importance
       register                 0
       business_impact          0
       notifications_enabled    0
}

# Ok we start to be important
define service{
       name             production
       register         0
       business_impact  3
}


# It began to be very  important
define service{
       name             important
       register         0
       business_impact  4
}


# TOP FOR BUSINESS!
define service{
       name             top-for-business
       register         0
       business_impact  5
}

```

