
# Adding a Lustre client

Check the current status of the cluster through the Cyclecloud CLI:

```
> cyclecloud show_cluster scratch-fs
--------------------
scratch-fs : started
--------------------
Keypair:
Cluster nodes:
    mds:    Started 7b9653f48899a20d304b7e56c25c3082 40.113.142.239 (10.1.1.5)
Cluster node arrays:
     oss:    1 instances, 8 cores, Started
Total nodes: 2 
```

Now add a node to the cluster:
```
> cyclecloud add_node scratch-fs -t client
Adding nodes to cluster scratch-fs....
--------------------
scratch-fs : started
--------------------
Keypair:
Cluster nodes:
    mds:    Started 7b9653f48899a20d304b7e56c25c3082 40.113.142.239 (10.1.1.5)
Cluster node arrays:
     oss:    1 instances, 8 cores, Started
     client: 1 instances, 8 cores, Validation (Staging resources)
Total nodes: 3
```

Once the client node is started, login and check the available storage:
```
catcycle connect client-1 -c scratch-fs
Warning: Permanently added '10.1.1.7' (ECDSA) to the list of known hosts.
Last login: Mon Apr  1 18:43:23 2019 from ip-0a010105.aksotx52fr0uri1s5xmrilcood.ax.internal.cloudapp.net

 __        __  |    ___       __  |    __         __|
(___ (__| (___ |_, (__/_     (___ |_, (__) (__(_ (__|
        |

Cluster: scratch-fs
Version: 7.7.2
Run List: recipe[cyclecloud], recipe[lustre::client], recipe[cluster_init]
[cycleadmin@ip-0A010107 ~]$ df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2              30G  1.9G   28G   7% /
devtmpfs               32G     0   32G   0% /dev
tmpfs                  32G     0   32G   0% /dev/shm
tmpfs                  32G  8.4M   32G   1% /run
tmpfs                  32G     0   32G   0% /sys/fs/cgroup
/dev/sda1             497M   77M  421M  16% /boot
/dev/sdb1              79G   57M   75G   1% /mnt/resource
10.1.1.5@tcp:/lustre  1.8T   69M  1.7T   1% /lustre
tmpfs                 6.3G     0  6.3G   0% /run/user/20000
[cycleadmin@ip-0A010107 ~]$
```

Lustre is mounted and available as /lustre; and a single OSS/OST gives about 1.7TB of storage capacity.

