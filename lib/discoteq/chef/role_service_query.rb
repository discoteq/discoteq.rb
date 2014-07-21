require_relative 'service_query'

module Discoteq
  module Chef
    # provides a chef serivce query for nodes with the same role as the
    # name of the service
    class RoleServiceQuery < ServiceQuery
      def initialize(id, opts)
        opts['query'] = "role:\"#{id}\""
        super
      end
    end
  end
end
