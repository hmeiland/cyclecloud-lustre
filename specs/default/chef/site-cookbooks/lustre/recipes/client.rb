# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
include_recipe "::default"

%w{lustre-client lustre-client-dkms}.each { |p| package p }
manager_ipaddress = node["lustre"]["manager_ipaddress"]

bash 'initialize client' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  echo "my ip is #{manager_ipaddress}"
  mkdir -p /lustre
  EOH
end
#mount -t lustre #{manager_ipaddress}@tcp0:/lustre /lustre
if File.read('/etc/mtab').lines.grep(/ lustre /)[0]
  Chef::Log.info("Lustre is already mounted")
else
  mount '/lustre' do
    device "#{manager_ipaddress}@tcp0:/lustre"
    fstype 'lustre'
    #options 'rw'
    action [:mount, :enable]
  end
end

