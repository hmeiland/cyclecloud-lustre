# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
include_recipe "::default"

#%w{lustre kmod-lustre-osd-ldiskfs lustre-dkms lustre-osd-ldiskfs-mount lustre-resource-agents e2fsprogs lustre-tests}.each { |p| package p }
package %w(lustre kmod-lustre-osd-ldiskfs lustre-osd-ldiskfs-mount lustre-resource-agents e2fsprogs lustre-tests)


if node["recipes"].include? "lustre::mds"
  ost_index = (0).to_s
  manager_ipaddress = node["ipaddress"]
else
  ost_index = (node[:azure][:metadata][:compute][:name].split('_')[1].to_i + 1).to_s
  manager_ipaddress = node["lustre"]["manager_ipaddress"]
end

if File.read('/etc/mtab').lines.grep(/ lustre /)[0]
  Chef::Log.info("Lustre ost is already mounted")
else
  bash 'initialize oss' do
    user 'root'
    cwd '/tmp'
    code <<-EOH
    echo "connecting to mds #{manager_ipaddress}"
    echo "creating oss index #{ost_index}"
    weak-modules --add-kernel --no-initramfs
    mkfs.lustre --ost --fsname LustreFS --mgsnode #{manager_ipaddress}@tcp0 --index=#{ost_index} --reformat /dev/nvme0n1
    EOH
  end
end

unless Dir.exist? '/mnt/ost'
  directory '/mnt/ost' do
    owner 'root'
    group 'root'
    mode '0777'
    action [:create]
  end
end

if File.read('/etc/mtab').lines.grep(/ lustre /)[0]
  Chef::Log.info("Lustre ost is already mounted")
else
  mount '/mnt/ost' do
    device "/dev/nvme0n1"
    fstype 'lustre'
    options 'noatime,nodiratime,nobarrier'
    action [:mount, :enable]
  end
end
