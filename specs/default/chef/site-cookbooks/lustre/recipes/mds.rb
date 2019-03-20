# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
include_recipe "::default"
node.override["lustre"]["is_manager"] = true
cluster.store_discoverable()

%w{lustre kmod-lustre-osd-ldiskfs lustre-dkms lustre-osd-ldiskfs-mount lustre-resource-agents e2fsprogs lustre-tests}.each { |p| package p }

manager_ipaddress = node["lustre"]["manager_ipaddress"]

bash 'initialize mds' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  echo "my ip is #{manager_ipaddress}"
  mkfs.lustre --fsname=lustre --mgs --mdt --index=0 /dev/nvme0n1
  mkdir -p /mnt/mdsmgs
  mount -t lustre /dev/nvme0n1 /mnt/mdsmgs
  EOH
end

