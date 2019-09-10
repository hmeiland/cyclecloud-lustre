# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
include_recipe "::default"

#%w{lustre-client lustre-client-dkms}.each { |p| package p }
#%w{lustre-client kmod-lustre-client}.each { |p| package p }
package %w(lustre-client kmod-lustre-client)
manager_ipaddress = node["lustre"]["manager_ipaddress"]

bash 'initialize weak modules' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
weak-modules --add-kernel --no-initramfs 
  EOH
end

if node["lustre"]["client"]["mount_point"]
  mount_point = node["lustre"]["client"]["mount_point"]
else
  mount_point = "/lustre" 
end

#directory '/lustre' do
directory "#{mount_point}" do
  owner 'root'
  group 'root'
  mode '0777'
  action [:create]
end

#mount -t lustre #{manager_ipaddress}@tcp0:/lustre /lustre
if File.read('/etc/mtab').lines.grep(/ lustre /)[0]
  Chef::Log.info("Lustre is already mounted")
else
  #mount '/lustre' do
  mount "#{mount_point}" do
    device "#{manager_ipaddress}@tcp0:/LustreFS"
    fstype 'lustre'
    #options 'rw'
    action [:mount, :enable]
  end
end

