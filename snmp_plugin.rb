#
# Copyright 2011 David Dossot
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# A Scout Plugin for reading SNMP values.
#
class SnmpPlugin < Scout::Plugin
  needs 'snmp'
  
  OPTIONS=<<-EOS
    host:
      name: host to connect to
      default: localhost
      
    port:
      name: port to connect to
      default: 161
      
    community:
      name: community string
      default: public
      
    version:
      name: protocol version
      default: SNMPv2c
      
    targets:
      name: names or OIDs
      notes: A comma separated list of names or OIDs to read values from.
      default:
      
    walk:
      name: should walk the tree?
      notes: If set to true, each target will be will be walked and all values found returned. Otherwise, if false, targets are read directly, returning a single value each.
      default: false
  EOS
  
  def build_report
    if option(:targets).nil? or option(:targets).empty?
      return error("At least one binding or OID must be specified", "No binding nor OID specified in option: targets") 
    end
    
    manager = SNMP::Manager.new(:Host => option(:host),
                                :Port => option(:port),
                                :Community => option(:community),
                                :Version => option(:version).to_sym)
    
    object_list = option(:targets).split ','
    report_content = {}
    
    if option(:walk) then
      manager.walk(object_list) do |row|
        row.each { |vb| report_content[vb.name.to_s] = vb.value }
      end
    else
      manager.get(object_list).each_varbind do |vb|
        report_content[vb.name.to_s] = vb.value
      end
    end
    
    manager.close
    report(report_content)
  end
end
