# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
include_recipe "::default"

#%w{git lustre-client lustre-client-dkms}.each { |p| package p }
package %w(git gcc)

#manager_ipaddress = node["lustre"]["manager_ipaddress"]

bash 'build hsm-import' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
yum install -y https://github.com/whamcloud/lemur/releases/download/0.5.2/lhsm-0.5.2-1.x86_64.rpm
wget https://dl.google.com/go/go1.12.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.12.1.linux-amd64.tar.gz
export PATH=/usr/local/go/bin:$PATH
go get -u github.com/edwardsp/lemur/cmd/azure-import
go build github.com/edwardsp/lemur/cmd/azure-import
mkdir -p /usr/local/bin
sudo cp azure-import /usr/local/bin/.
  EOH
  not_if { ::File.exist?('/usr/local/bin/azure-import') }
end

