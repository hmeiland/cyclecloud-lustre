# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
include_recipe "::default"
#include_recipe "::_tune_beegfs"
#node.override["lustre"]["is_manager"] = true
#cluster.store_discoverable()

%w{lustre-client lustre-client-dkms}.each { |p| package p }

# manager_ipaddress = ::BeeGFS::Helpers.search_for_manager(node['cyclecloud']['cluster']['id'])
manager_ipaddress = node["lustre"]["manager_ipaddress"]

chef_state =  node['cyclecloud']['chefstate']
lustre_meta_conf_file = "/etc/lustre/lustre-meta.conf"
hostname_line = "sysMgmtdHost = #{manager_ipaddress}"

bash 'initialize cleint' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  echo "my ip is #{manager_ipaddress}"
  mkdir -p /lustre
  mount -t lustre #{manager_ipaddress}@tcp0:/lustre /lustre
  EOH
end

