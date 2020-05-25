# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
include_recipe "::default"

package %w(git lustre kmod-lustre-client)

manager_ipaddress = node["lustre"]["manager_ipaddress"]

bash 'initialize weak modules' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
weak-modules --add-kernel --no-initramfs
  EOH
end

bash 'build hsm' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
yum install -y https://azurehpc.azureedge.net/rpms/lemur-azure-hsm-agent-1.0.0-lustre_2.12.x86_64.rpm https://azurehpc.azureedge.net/rpms/lemur-azure-data-movers-1.0.0-lustre_2.12.x86_64.rpm
  EOH
  not_if { ::File.exist?('/usr/libexec/lhsmd/lhsm-plugin-az') }
end

directory '/var/run/lhsmd' do
  owner 'root'
  group 'root'
  mode '0755'
  action [:create]
end

directory '/etc/lhsmd' do
  owner 'root'
  group 'root'
  mode '0755'
  action [:create]
end

directory '/lustre' do
  owner 'root'
  group 'root'
  mode '0777'
  action [:create]
end

template '/etc/lhsmd/agent' do
  source 'hsm/agent.erb'
  owner 'root'
  group 'root'
  mode '0600'
end

template '/etc/lhsmd/lhsm-plugin-az' do
  source 'hsm/lhsm-plugin-az.erb'
  owner 'root'
  group 'root'
  mode '0600'
end

template '/etc/systemd/system/lhsmd.service' do
  source 'hsm/lhsmd.service.erb'
  owner 'root'
  group 'root'
  mode '0600'
end
bash 'start lhsmd' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
systemctl daemon-reload
#systemctl enable lhsmd
#systemctl start lhsmd
  EOH
end
systemd_unit 'lhsmd' do
  action [:enable, :start]
end

#mount -t lustre #{manager_ipaddress}@tcp0:/lustre /lustre
#if File.read('/etc/mtab').lines.grep(/ lustre /)[0]
#  Chef::Log.info("Lustre is already mounted")
#else
#  mount '/lustre' do
#    device "#{manager_ipaddress}@tcp0:/lustre"
#    fstype 'lustre'
    #options 'rw'
#    action [:mount, :enable]
#  end
#end

