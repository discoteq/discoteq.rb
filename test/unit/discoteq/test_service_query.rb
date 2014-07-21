#!/usr/bin/env ruby -w
require_relative '../helper'
require 'minitest/autorun'

require 'discoteq/service_query'

# Test ServiceQuery edge case behaviour
class TestServiceQuery < Minitest::Test
  def test_build_delegates_by_type
    sq = Discoteq::ServiceQuery.build(
      'myface',
      type: :explicit,
      records: [{hostname: 'myface-lb'}]
    )

    actual = sq.class.to_s
    expected = 'Discoteq::ExplicitServiceQuery'
    assert_equal expected, actual
  end
end

# Test failure exception for unrecognized query type
class TestUnrecognizedQuery < Minitest::Test
end
