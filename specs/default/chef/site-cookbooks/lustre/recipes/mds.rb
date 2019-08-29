# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
include_recipe "::default"
node.override["lustre"]["is_manager"] = true
cluster.store_discoverable()

package %w(lustre kmod-lustre-osd-ldiskfs lustre-osd-ldiskfs-mount lustre-resource-agents e2fsprogs lustre-tests)

manager_ipaddress = node["lustre"]["manager_ipaddress"]

directory '/mnt/mdsmgs' do
  owner 'root'
  group 'root'
  mode '0777'
  action [:create]
end

bash 'initialize mds' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
echo "my ip is #{manager_ipaddress}"
sed -i 's/ResourceDisk\.Format=y/ResourceDisk.Format=n/g' /etc/waagent.conf
systemctl restart waagent
weak-modules --add-kernel --no-initramfs
umount /mnt/resource
mkfs.lustre --fsname=LustreFS --mgs --mdt --backfstype=ldiskfs --reformat /dev/sdb1 --index 0
  EOH
end

if File.read('/etc/mtab').lines.grep(/ lustre /)[0]
  Chef::Log.info("Lustre mds-mgs is already mounted")
else
  mount '/mnt/mdsmgs' do
    device "/dev/sdb1"
    fstype 'lustre'
    options 'noatime,nodiratime,nobarrier'
    action [:mount, :enable]
  end
end

bash 'tweak lctl settings' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
# enable HSM
lctl set_param -P mdt.*-MDT0000.hsm_control=enabled
lctl set_param -P mdt.*-MDT0000.hsm.default_archive_id=1
lctl set_param mdt.*-MDT0000.hsm.max_requests=128
# allow any user and group ids to write
lctl set_param mdt.*-MDT0000.identity_upcall=NONE
  EOH
end

