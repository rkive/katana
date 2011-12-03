## Knife plugin to apply a run_list entry to all nodes within a search query.
#
## Install
# Place in .chef/plugins/knife/katana.rb
#
## Usage
#$ knife katana "chef_environment:abento" "role[addedrole]"   
#
#Adding entry to: node[role2.abento.aws.p0.com]
#run_list: 
#    role[base]
#    role[role2]
#    role[addedrole]
#
#Adding entry to: node[role3.abento.aws.p0.com]
#run_list: 
#    role[base]
#    role[role3]
#    role[addedrole]
#
#Adding entry to: node[role1.abento.aws.p0.com]
#run_list: 
#    role[base]
#    role[role1]
#    role[addedrole]

require 'chef/knife'
 
module Daisho
  class Katana < Chef::Knife
 
    deps do
      require 'chef/search/query'
    end

    banner "knife katana [ENVIRONMENT] [ENTRY]"
      
    def run
      unless name_args.size == 2
        ui.fatal "You must provide a search query and run_list entry"
        exit 1
      end
      
      query = @name_args[0]
      entry = @name_args[1]

      q = Chef::Search::Query.new
      q.search(:node, query) do |node|
        ui.msg("\nAdding #{entry} to: #{node}")
        
        a = Chef::Knife::NodeRunListAdd.new
        a.add_to_run_list(node, entry, config[:after])  
        
        node.save
        config[:run_list] = true
        output(format_for_display(node))
      end
    end
      
  end
end
