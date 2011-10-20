# SNMP Plugin for Scout

- Monitor applications/systems over SNMP with [Scout](https://scoutapp.com/).
- Made possible by the super-awesome [Ruby SNMP gem](http://snmplib.rubyforge.org/).

## Examples

The following demonstrates the capacity of the plugin by first running sample SNMP queries from the command line then showing the equivalent done with the plugin.

### Multiple gets

Command line:

    $ snmpget -v 2c -c public 127.0.0.1 sysServices.0 1.3.6.1.4.1.12046.1.2.6.0
    
    SNMPv2-MIB::sysServices.0 = INTEGER: 72
    SNMPv2-SMI::enterprises.12046.1.2.6.0 = STRING: "0 days, 0 hours, 21 minutes and 4 seconds"

Plugin:

    $ scout test snmp_plugin.rb targets=sysServices.0,1.3.6.1.4.1.12046.1.2.6.0
    
    == Output:
    {:reports=>
      [{:plugin_id=>nil,
        :created_at=>"2011-10-20 16:15:32",
        :fields=>
         {"1.3.6.1.2.1.1.7.0"=>72,
          "1.3.6.1.4.1.12046.1.2.6.0"=>
           "0 days, 0 hours, 26 minutes and 4 seconds"},
        :local_filename=>nil,
        :origin=>nil}],
    ...

### Tree walk

Command line:

    $ snmpwalk -v 2c -c public 127.0.0.1 1.3.6.1.4.1.12046.1.4
    SNMPv2-SMI::enterprises.12046.1.4.1.1.1.98.101.116.97 = STRING: "beta"
    SNMPv2-SMI::enterprises.12046.1.4.1.1.2.98.101.116.97 = Gauge32: 5000
    SNMPv2-SMI::enterprises.12046.1.4.1.1.3.98.101.116.97 = Gauge32: 4515

Plugin:

    $ scout test snmp_plugin.rb targets=1.3.6.1.4.1.12046.1.4 walk=true
    
    == Output:
    {:reports=>
      [{:plugin_id=>nil,
        :created_at=>"2011-10-20 16:30:35",
        :fields=>
         {"1.3.6.1.4.1.12046.1.4.1.1.1.98.101.116.97"=>"beta",
          "1.3.6.1.4.1.12046.1.4.1.1.2.98.101.116.97"=>5000,
          "1.3.6.1.4.1.12046.1.4.1.1.3.98.101.116.97"=>4515},
        :local_filename=>nil,
        :origin=>nil}],
    ...
    
#### Copyright 2011 - David Dossot - MIT License
