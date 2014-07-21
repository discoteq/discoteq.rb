#!/usr/bin/env ruby -w
require_relative '../helper'
require 'minitest/autorun'

require 'discoteq/explicit_service_query'

# Test ExplicitServiceQuery edge case behaviour
class TestExplicitServiceQuery < Minitest::Test
  def test_records
    sq = Discoteq::ExplicitServiceQuery.new(
      'myface',
      'records' => [{'hostname' => 'myface-lb.example.net'}])

    actual = sq.records
    expected = [{'hostname' => 'myface-lb.example.net'}]
    assert_equal expected, actual
  end
end
