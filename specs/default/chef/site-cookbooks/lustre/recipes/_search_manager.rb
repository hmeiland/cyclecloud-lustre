# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
manager_ipaddress = nil
cluster_id = node['cyclecloud']['cluster']['id']

# if this is the manager node, or if the client has specifed a ipaddress, use it
if node["recipes"].include? "lustre::client" 
    if not node["lustre"]["client"]["manager_ipaddress"].nil? 
        manager_ipaddress = node["lustre"]["client"]["manager_ipaddress"]          
    elsif not node["lustre"]["client"]["cluster_name"].nil?
        cluster_id = node["lustre"]["client"]["cluster_name"]
    end
elsif node["recipes"].include? "lustre::mds"
    manager_ipaddress = node["ipaddress"]
end

# Search for manager ipaddress otherwise:
if manager_ipaddress.nil?
    nodes = Lustre::Helpers.search_for_manager(1, 30) do
        nodes = cluster.search(:clusterUID => cluster_id).select { |n|
            if not n['lustre'].nil?
                if not n['lustre']['is_manager'].nil?
                    Chef::Log.info("Found #{n['ipaddress']} as Lustre manager")
                end
            end
        }
    end
    if nodes.length > 1
        raise("Found more than one manager node")
    end
    manager_ipaddress = nodes[0]['ipaddress'] 
end

node.override["lustre"]["manager_ipaddress"] = manager_ipaddress
