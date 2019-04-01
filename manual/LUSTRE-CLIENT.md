
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


