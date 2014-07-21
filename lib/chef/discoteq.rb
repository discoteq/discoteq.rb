require 'discoteq'

class Chef
  # ServiceDisco provides helpers for doing service discovery
  module ServiceDisco
    # Return a list of Discoteq::Services for each of the service_names
    #
    # Examples:
    #
    #     foo_services = service_disco %w(statsd foo-cache foo-db)
    def service_disco(service_names)
      Discoteq.service_map.select {|k, _| service_names.include? k}
    end
  end
end

class Chef
  # Mix Chef::ServiceDisco into Chef::Recipe
  class Recipe
    include Chef::ServiceDisco
  end
end
