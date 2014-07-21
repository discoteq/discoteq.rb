# TODO: investigate autoload
require 'discoteq/log'
require 'discoteq/chef'
require 'discoteq/config'
require 'discoteq/service_map'
require 'discoteq/service_query'
require 'discoteq/version'

# Discoteq: a service discovery toolkit for all and none
module Discoteq
  # generate a ServiceMap from the query_map in config
  def self.service_map
    unless config['query_map']
      fail ArgumentError, 'config requires a "query_map" attribute, ' \
        'see the README for more details'
    end
    config.prepare!
    ServiceMap.new.tap do |sm|
      config['query_map'].each do |k, v|
        sm[k] = ServiceQuery.build(k, v).records
      end
    end
  end

  # provide a new config for access
  def self.config
    @config ||= Config.new
  end

  # ensure a config is loaded as a config object
  def self.config=(obj)
    if obj.nil?
      @config = nil
    else
      @config = Config[obj]
    end
  end
end
