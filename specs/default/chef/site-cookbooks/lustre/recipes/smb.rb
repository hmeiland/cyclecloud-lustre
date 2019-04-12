# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
include_recipe "::client"

%w{samba samba-client samba-common}.each { |p| package p }

template '/etc/samba/smb.conf' do
  source 'smb/smb.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

systemd_unit 'smb' do
  action [:enable, :start]
end


