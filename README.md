
# Lustre

Lustre is a High Performance Parallel Filesystem, often used in High Performance Computing. These Cyclecloud project and templates allow to quickly set up a Lustre cluster, consisting of a MDS node and one or more OSS nodes.

This cluster is designed to be for scratch data; utilizing the local NVME drives of the L_v2 nodes.

On top of this, HSM can be activated to import data from, and archive to Azure blobs. 

# Getting started

```
> git clone https://github.com/hmeiland/cyclecloud-lustre.git
> cd cyclecloud-lustre
> cyclecloud project upload <container>
> cyclecloud import_template -f templates/lustre.txt 
```

 - [set up first Lustre in CycleCloud](manual/FIRST-LUSTRE.md)
 - [adding a client and using lustre](manual/LUSTRE-CLIENT.md)
 - [configure a client in a PBSPro cluster](manual/PBSPRO.md)
 - [using HSM](manual/HSM.md)

# Updates
Version 1.0.1
- bumped to Lustre 2.10.8
- verified on CentOS 7.6
- moved from dkms to weak-modules (>10 min config to <3 min)
- moved bash actions into chef actions where possible

Version 1.0.0
- initial release based on 2.10.6
- verified on CentOS 7.4

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
