default['lustre']['repo']['version'] = 'latest-2.10-release/el7.6.1810'

default['lustre']['repo']['yum']['baseurl'] = "https://downloads.whamcloud.com/public/lustre/#{node['lustre']['repo']['version']}/patchless-ldiskfs-server/"
default['lustre']['repo']['yum']['gpgcheck'] = false 

default['lustre-client']['repo']['yum']['baseurl'] = "https://downloads.whamcloud.com/public/lustre/#{node['lustre']['repo']['version']}/client/"
default['lustre-client']['repo']['yum']['gpgcheck'] = false 

default['e2fs']['repo']['yum']['baseurl'] = "https://downloads.whamcloud.com/public/e2fsprogs/latest/el7/"
default['e2fs']['repo']['yum']['gpgcheck'] = false 

# the directory on the MGS, MDS and OSS where the Lustre data resides
default['lustre']['root_dir'] = '/data/lustre'
default['lustre']['manager_ipaddress'] = nil

# Lustre Clients
# Allow clients to specify a specific MGS, or a clustername to connect to
# Order of precedence:
# 1. manager_ipaddress
# 2. cluster_name
# 3. the parent cluster the client belongs to
default['lustre']['client']['manager_ipaddress'] = nil
default['lustre']['client']['cluster_name'] = nil

# The mount point for the Lustre clients
default['lustre']['client']['mount_point'] = ''
