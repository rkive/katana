## Knife plugin to remove a run_list entry from all nodes within a search query.
#
## Install
# Place in .chef/plugins/knife/wakizashi.rb
#
## Usage
#$ knife wakizashi "chef_environment:abento" "role[addedrole]"
#
#Removing role[addedrole] from: node[role2.abento.aws.p0.com]
#run_list: 
#    role[base]
#    role[role2]
#
#Removing role[addedrole] from: node[role3.abento.aws.p0.com]
#run_list: 
#    role[base]
#    role[role3]
#
#Removing role[addedrole] from: node[role1.abento.aws.p0.com]
#run_list: 
#    role[base]
#    role[role1]

require 'chef/knife'
 
module Daisho
  class Wakizashi < Chef::Knife
 
    deps do
      require 'chef/search/query'
    end

    banner "knife wakizashi [ENVIRONMENT] [ENTRY]"
      
    def run
      unless name_args.size == 2
        ui.fatal "You must provide a search query and run_list entry"
        exit 1
      end
      
      query = @name_args[0]
      entry = @name_args[1]

      q = Chef::Search::Query.new
      q.search(:node, query) do |node|
        ui.msg("\nRemoving #{entry} from: #{node}")
        
        node.run_list.remove(entry)
        
        node.save
        config[:run_list] = true
        output(format_for_display(node))
      end
    end
      
  end
end
