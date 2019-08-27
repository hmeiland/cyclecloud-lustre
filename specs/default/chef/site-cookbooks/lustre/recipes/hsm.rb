# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
include_recipe "::default"

#%w{git lustre-client lustre-client-dkms}.each { |p| package p }
package %w(git lustre-client kmod-lustre-client)

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
yum install -y https://github.com/whamcloud/lemur/releases/download/0.5.2/lhsm-0.5.2-1.x86_64.rpm https://github.com/whamcloud/lemur/releases/download/0.5.2/lemur-data-movers-0.5.2-1.x86_64.rpm https://github.com/whamcloud/lemur/releases/download/0.5.2/lemur-hsm-agent-0.5.2-1.x86_64.rpm https://github.com/whamcloud/lemur/releases/download/0.5.2/lemur-testing-0.5.2-1.x86_64.rpm
wget https://dl.google.com/go/go1.12.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.12.1.linux-amd64.tar.gz
export PATH=/usr/local/go/bin:$PATH
go get -u github.com/edwardsp/lemur/cmd/lhsm-plugin-az
go build github.com/edwardsp/lemur/cmd/lhsm-plugin-az
sudo cp lhsm-plugin-az /usr/libexec/lhsmd/.
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

