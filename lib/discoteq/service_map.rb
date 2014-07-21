require 'json'

module Discoteq
  # ServiceMap represents the mapping of a service
  # name onto its list of ServiceHostRecords
  #
  # e.g.
  #     sm = ServiceMap.new
  #     sm['myface'] ||= []
  #     sm['myface'] << ServiceHostRecord.new(
  #       host: 'myface.example.net',
  #       port: 8080)
  #     sm.to_json
  #     =>
  #       {
  #         "myface": [
  #           {
  #             "host": "myface.example.net",
  #             "port": 8080
  #           }
  #         ]
  #       }
  class ServiceMap < Hash
    def to_h
      Hash[map {|k, v| [k, v.map(&:to_h)]}]
    end
    # Serializes to a JSON string, ensuring each service is
    # fully serialized
    def to_json
      to_h.to_json
    end
  end
end
