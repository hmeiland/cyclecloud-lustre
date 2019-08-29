
# Using HSM on Lustre and Azure Blob 

Lustre filesystem support Hierarchical Storage Management and with this Lustre setup this is implemented with a Azure Blob backend. The implementation allows for access to the files in the native blob format, so once archived the files can be viewed and accessed through e.g. the Azure Storage Explorer. Also files can be easily imported from Azure Blob and cached onto Lustre.

To create a 5GB file and view the HSM state with lfs:
```
> dd if=/dev/zero of=./testfile bs=1M count=5000
> lfs hsm_state testfile
testfile: (0x00000000)
```
So the file is now in Lustre, but not in Blob.

Now the file can be archived into Blob:
```
> sudo lfs hsm_archive testfile
> lfs hsm_state testfile
testfile: (0x00000009) exists archived, archive_id:1
``` 
and depending on the size, after a few moments the file can also be found in your Blob container in the lustre-archive folder.

To sync a complete container from Azure Blob to Lustre, a tool is created: azure-import. This tool will create file-pointers for all objects in your container. These file pointers will be set up as archived/released, so the actual file data will not be on lustre untill the file is restored. This restoring will be done when the file is touched by e.g. cat; or when the file is resored using lfs hsm_restore.

     
