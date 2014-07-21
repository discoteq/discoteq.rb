require_relative 'service_query'

module Discoteq
  # ExplicitServiceQuery lets you simply hardcode service
  # records, so you can have a config like:
  #   {
  #     "myface-fascade": {
  #       "type": "explicit",
  #       "records": [
  #         {
  #           "hostname": "myface-lb.example.net"
  #         }
  #       ]
  #     }
  #   }
  #
  # or create an instance like:
  #   ExplicitServiceQuery.new('myface',
  #     records: [{hostname: myface-lb.example.net'}])
  #
  # both of which will result in a record list of:
  #   [
  #     {
  #       "hostname": "myface-lb.example.net"
  #     }
  #   ]
  class ExplicitServiceQuery < ServiceQuery
    attr_accessor :records
    def initialize(id, opts)
      unless opts.key? 'records'
        fail ArgumentError, 'ExplicitServiceQuery opts must ' \
          "contain 'records', was: #{opts.inspect}"
      end
      @id = id
      @records = opts.fetch 'records'
    end
  end
end
