#!/usr/bin/env ruby -w
require_relative '../../helper'
require 'discoteq/chef/service_query'

# Test Chef::ServiceQuery edge case behaviour
class TestChef < Minitest::Test
  def test_opts_must_be_hash
    assert_raises(ArgumentError) do
      Discoteq::Chef::ServiceQuery.new(:foo, :not_a_hash)
    end
  end
end
