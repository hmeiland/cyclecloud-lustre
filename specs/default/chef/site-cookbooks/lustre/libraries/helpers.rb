# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
module Lustre 
    class Helpers
        def self.search_for_manager(min_count=1, sleep_time=10, max_retries=6, &block)
            results = block.call
            retries = 0
            while results.length < min_count and retries < max_retries
              sleep sleep_time
              retries += 1
              results = block.call
              Chef::Log.info "Found #{results.length} nodes that match Lustre MDS"
            end
            if retries >= max_retries
              raise Exception, "Timed out searching for Lustre MDS"
            end
      
            results
          end
      
    end
end
