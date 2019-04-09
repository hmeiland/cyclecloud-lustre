# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

node.override['cyclecloud']['maintenance_converge']['enabled'] = false

yum_repository 'lustre' do
  description "Lustre #{node['lustre']['repo']['version']} (rhel#{node['platform_version'].to_i})"
  baseurl node['lustre']['repo']['yum']['baseurl']
  gpgcheck node['lustre']['repo']['yum']['gpgcheck']
  only_if { node['platform_family'] == 'rhel' }
end
yum_repository 'lustre-client' do
  description "Lustre client #{node['lustre']['repo']['version']} (rhel#{node['platform_version'].to_i})"
  baseurl node['lustre-client']['repo']['yum']['baseurl']
  gpgcheck node['lustre-client']['repo']['yum']['gpgcheck']
  only_if { node['platform_family'] == 'rhel' }
end
yum_repository 'e2fs' do
  description "e2fs (rhel#{node['platform_version'].to_i})"
  baseurl node['e2fs']['repo']['yum']['baseurl']
  gpgcheck node['e2fs']['repo']['yum']['gpgcheck']
  only_if { node['platform_family'] == 'rhel' }
end

include_recipe '::_search_manager'

manager_ipaddress = node['lustre']['manager_ipaddress']

