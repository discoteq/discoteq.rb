#!/usr/bin/env ruby -w
require_relative '../helper'
require 'minitest/autorun'

require 'discoteq/service_map'

# TestServiceMap does exactly what you'd expect
class TestServiceMap < Minitest::Test
  def setup
    @sm = Discoteq::ServiceMap.new
    @sm['myface'] ||= []
    # @sm['myface'] << ServiceHostRecord.new(
    #   host: 'myface.example.net',
    #   port: 8080)
    @sm['myface'] << {
      'host' => 'myface.example.net',
      'port' => 8080
    }
  end

  def test_to_h
    actual = @sm.to_h
    expected =
      { 'myface' => [
        { 'host' => 'myface.example.net',
          'port' => 8080}]}
    assert_equal expected, actual
  end

  def test_to_json
    actual = @sm.to_json
    expected = <<-JSON
      {
        "myface": [
          {
            "host": "myface.example.net",
            "port": 8080
          }
        ]
      }
    JSON
    assert_equal JSON.load(expected).to_json, actual
  end
end
