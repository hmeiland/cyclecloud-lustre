
# Lustre

Lustre is a High Performance Parallel Filesystem, often used in High Performance Computing. These Cyclecloud project and templates allow to quickly set up a Lustre cluster, consisting of a MDS node and one or more OSS nodes.

This cluster is designed to be for scratch data; utilizing the local NVME drives of the L_v2 nodes.

On top of this, HSM can be activated to import data from, and archive to Azure blobs. 

# Getting started

```
> git clone https://github.com/hmeiland/cyclecloud-lustre.git
> cd cyclecloud-lustre
> cycleloud project upload <container>
> cyclecloud import_template -f templates/lustre.txt 
```

[set up first Lustre in CycleCloud](manual/FIRST-LUSTRE.md)

[adding a client and using lustre](manual/LUSTRE-CLIENT.md)

[configure a client in a PBSPro cluster](manual/PBSPRO.md)

[using HSM](manual/HSM.md)


# First Lustre Filesystem

Create a new cluster by selecting the + button at the bottom of the cluster list:
![Create new cluster](manual/create-new-cluster.png?raw=true)

Fill in the cluster name e.g. scratch-fs (I will refer back to this name later on):
![cluster name](manual/cluster-name.png?raw=true)

Select the region where to deploy the scratch-fs, leave the default node types (hard references to /dev/nvme0n1, so other nodes will not work today), and select the subnet to deploy to. If no subnet is available in the drop-down list: create one.
![required-settings](manual/required-settings.png?raw=true)

Leave the defaults here...
![advanced-settings](manual/advanced-settings.png?raw=true)

If you want to use HSM (Hierarchical Storage Management), give the details on your Azure storage blob to use:
![lustre-settings](manual/lustre-settings.png?raw=true)

That's it! Save the config and start your cluster; this will set up the MDS. Since the lustre kernel bits are built during bootup through dkms, it might take a couple (~8 or so) of minutes to boot.

After the MDS has started, you can add the first oss node, to actually be able to store data; select the action button from the cluster and add node:
![add-oss](manual/add-oss.png?raw=true)

# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
