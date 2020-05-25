# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
include_recipe "::default"

bash 'build hsm-import' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
yum install -y https://azurehpc.azureedge.net/rpms/lemur-azure-hsm-agent-1.0.0-lustre_2.12.x86_64.rpm https://azurehpc.azureedge.net/rpms/lemur-azure-data-movers-1.0.0-lustre_2.12.x86_64.rpm
  EOH
  not_if { ::File.exist?('/usr/sbin/azure-import') }
end

