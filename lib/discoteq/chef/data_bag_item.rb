module Discoteq
  module Chef
    # DataBagItem provides a common way to directly access data bags
    class DataBagItem
      def self.load(bag_id, id)
        require 'chef/data_bag_item'
        ::Chef::DataBagItem.load(bag_id, id)
      end
      # TODO: support other clients
      # def self.load_via_chef_api(bag_id, id)
      #   require 'chef-api'
      #   ChefAPI::Resource::DataBagItem.fetch(bag_id, id)
      # end
      # def self.load_via_ridley(bag_id, id)
      #   require 'ridley'
      #   client = Ridley.new
      #   client.data_bag.find(bag_id).find(id)
      # end
    end
  end
end
