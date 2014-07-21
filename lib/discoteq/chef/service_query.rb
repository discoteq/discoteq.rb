require 'discoteq/core_ext/hash/stringify_keys'
require_relative 'nodes'

module Discoteq
  module Chef
    # ServiceQuery will use Chef Search to find other nodes
    # matching a search query (skipping the current node) and
    # from those nodes will select a attributes from each node,
    # returning an array of service records.
    #
    # By default, it will select host items with a selector of `fqdn`
    #
    # Examples:
    #
    # Search using tags:
    #
    #     ServiceQuery.new(
    #       'es-logstash',
    #       type: :chef_tag,
    #       env: 'prod'
    #     )
    #
    # Search using multiple roles:
    #
    #     ServiceQuery.new(
    #       'es-members',
    #       type: :chef_query,
    #       query: '(role:es-master OR role:es-peer)',
    #       env: 'prod'
    #     )
    #
    # If a node attributes is are, it will be also
    # be included in each service record.
    #
    # Examples:
    #
    # Use the public interface for each node:
    #
    #     ServiceQuery.new('myface',
    #       type: :role,
    #       env: 'prod',
    #       attrs: {
    #         host: 'cloud.public_ipv4'
    #       }
    #     )
    #
    # Select the port and private ip address
    #
    #     ServiceQuery.new('myface',
    #       type: :role,
    #       env: 'prod',
    #       attrs: {
    #         host: 'cloud.private_ipv4'
    #         port: 'myface.port'
    #       }
    #     )
    class ServiceQuery
      attr_accessor :query, :attrs
      def initialize(id, opts)
        unless opts.respond_to?(:fetch) && opts.respond_to?(:key?)
          fail ArgumentError, 'ServiceQuery requires opts to be a ' \
            "hash, was: #{opts.inspect}"
        end
        unless opts.key? 'query'
          fail ArgumentError, 'ServiceQuery requires opts to include ' \
            "entry for 'query', was: #{opts.inspect}"
        end
        @id = id
        @query = opts.fetch 'query'
        # append the chef_environment if provided
        if opts.key? 'env'
          @query << " AND chef_environment:\"#{opts.fetch 'env'}\""
        end
        @attrs = opts.fetch('attrs', {}).stringify_keys
        # default host selector is 'fqdn'
        @attrs['hostname'] ||= 'fqdn'
      end

      def records
        Chef::Nodes.find query, attrs
      end
    end
  end
end
