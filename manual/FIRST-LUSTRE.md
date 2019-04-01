
# First Lustre Filesystem

Create a new cluster by selecting the + button at the bottom of the cluster list:
![Create new cluster](create-new-cluster.png?raw=true)

Fill in the cluster name e.g. scratch-fs (I will refer back to this name later on):
![cluster name](cluster-name.png?raw=true)

Select the region where to deploy the scratch-fs, leave the default node types (hard references to /dev/nvme0n1, so other nodes will not work today), and select the subnet to deploy to. If no subnet is available in the drop-down list: create one.
![required-settings](required-settings.png?raw=true)

Leave the defaults here...
![advanced-settings](advanced-settings.png?raw=true)

If you want to use HSM (Hierarchical Storage Management), give the details on your Azure storage blob to use:
![lustre-settings](lustre-settings.png?raw=true)

That's it! Save the config and start your cluster; this will set up the MDS. Since the lustre kernel bits are built during bootup through dkms, it might take a couple (~8 or so) of minutes to boot.

After the MDS has started, you can add the first oss node, to actually be able to store data; select the action button from the cluster and add node:
![add-oss](add-oss.png?raw=true)

