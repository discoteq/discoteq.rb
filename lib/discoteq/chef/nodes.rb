require 'discoteq/log'
require 'discoteq/chef/config'

module Discoteq
  module Chef
    # Nodes represents a list of chef nodes, and exists to
    # encapsulate search and mapping to desired keys
    class Nodes
      def self.find(query, attr_map)
        require 'chef/search/query'
        results = []
        Discoteq::Log.debug(
          "Searching for nodes with query: \"#{query}\""
        )
        ::Chef::Search::Query.new.search(:node, query) do |node|
          results << Hash(attr_map.map do |key, attr|
            [key, fetch_attribute(node, attr)]
          end)
        end
      end
      # TODO: support partial search
      # TODO: support other clients
      # def self.find_via_chef_api(query)
      #   ChefAPI::Resource::Search.query(:node, query)
      # end
      # def self.find_via_ridley(query)
      #   client = Ridley.new
      #   ridley.search(:node, query)
      # end

      # Fetch an attribute value from a chef node. Allows accessing
      # nested attributes by seperating the keys with a `.`.
      # Raises an exception for a missing key.
      #
      # Common attributes include:
      # - fqdn
      # - ipaddress
      # - cloud.public_ipv4
      # - cloud.public_ipv6
      # - cloud.public_hostname
      # - cloud.local_ipv4
      # - cloud.local_ipv6
      # - cloud.local_hostname
      #
      # Examples:
      #
      # Select `node['cloud']['local_ipv4']` if present
      # or `node['ipaddress']` otherwise:
      #
      #   fetch_attribute(node)
      #
      # Select `node['fqdn']`:
      #
      #   fetch_attribute(node, 'fqdn')
      #
      # Select 'node['cloud']['local_hostname']`:
      #
      #   fetch_attribute(node, 'cloud.local_hostname')
      #
      def self.fetch_attribute(node, attribute)
        keys = attribute.split '.'
        value = keys.reduce node, :fetch
        Discoteq::Log.debug(
          "Selected attribute: #{attribute.inspect} " \
          "for node: #{node.name.inspect} " \
          "with value: #{value.inspect}"
        )
        value
      end
    end
  end
end
