
# Configuring PBSPro with Lustre 

Add the pbspro-lustre.txt template to Cyclecloud:

```
> cyclecloud import_template -f templates/pbspro-lustre.txt
Importing default template in templates/pbspro-lustre.txt....
--------------------------
PBSPro-lustre : *template*
--------------------------
Keypair:
Cluster nodes:
    login:  off
    master: off
Total nodes: 2
```

Now add a PBSPro-lustre cluster based on this template through the web portal, and 
make sure to select the Lustre Cluster you created earlier (e.g. scratch-fs) from the drop-down:
![Lustre Cluster name](pbspro-lustre-settings.png?raw=true)


Now the PBSPro-lustre cluster can be started either through the web-portal or the cli; the login node will have the /lustre filesystem mounted.

To add a Lustre filesystem to your own template, have a look at the pbspro-lustre example. Specifically at the node settings for the login / execute nodes and the parameter section, where some variables are defined.
