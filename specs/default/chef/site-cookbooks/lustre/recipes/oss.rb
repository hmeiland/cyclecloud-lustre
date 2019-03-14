# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
include_recipe "::default"
#include_recipe "::_tune_beegfs"

%w{lustre kmod-lustre-osd-ldiskfs lustre-dkms lustre-osd-ldiskfs-mount lustre-resource-agents e2fsprogs lustre-tests}.each { |p| package p }

#manager_ipaddress = ::Lustre::Helpers.search_for_manager(node['cyclecloud']['cluster']['id'])
manager_ipaddress = node["lustre"]["manager_ipaddress"]

chef_state =  node['cyclecloud']['chefstate']
lustre_meta_conf_file = "/etc/lustre/lustre-meta.conf"
hostname_line = "sysMgmtdHost = #{manager_ipaddress}"
ost_index = node[:azure][:metadata][:compute][:name].split('_')[1]

bash 'initialize oss' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  echo "connecting to mds #{manager_ipaddress}"
  echo "creating oss index #{ost_index}"
  mkfs.lustre --ost --fsname lustre --mgsnode #{manager_ipaddress}@tcp0 --index=#{ost_index} /dev/nvme0n1
  mkdir -p /mnt/ost/
  mount -t lustre /dev/nvme0n1 /mnt/ost/
  EOH
end

