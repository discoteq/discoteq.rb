require_relative 'service_query'

module Discoteq
  module Chef
    # provides a chef serivce query for nodes with the same tag as the
    # name of the service
    class TagServiceQuery < ServiceQuery
      def initialize(id, opts)
        opts['query'] = "tag:\"#{id}\""
        super
      end
    end
  end
end
