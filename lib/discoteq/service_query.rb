require 'discoteq/core_ext/string/constantize'
require 'discoteq/core_ext/hash/stringify_keys'

module Discoteq
  # ServiceQuery will take the type and delegate to the right command
  # to find nodes. A ServiceQuery takes an id and a set of options,
  # most importantly a query type, one of:
  #   :chef_role
  #   :chef_tag
  #   :chef_query
  #   :explicit
  class ServiceQuery
    TYPE_MAP = {
      'chef_role' => 'discoteq/chef/role_service_query',
      'chef_tag' => 'discoteq/chef/tag_service_query',
      'chef_query' => 'discoteq/chef/service_query',
      'explicit' => 'discoteq/explicit_service_query'
    }

    ALLOWED_TYPES = TYPE_MAP.keys

    def self.build(id, opts)
      opts = opts.stringify_keys
      type = opts['type'].to_s

      unless ALLOWED_TYPES.include? type
        fail ArgumentError, 'Service :type must be one of ' \
          "#{ALLOWED_TYPES.inspect}, was: #{type.inspect}"
      end

      path = TYPE_MAP[type]
      require path
      klass = path.camelize.constantize
      klass.new(id, opts)
    end

    # records returns the list of service records for each host
    def records
      fail 'Not yet implemented'
    end
  end
end
