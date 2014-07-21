#!/usr/bin/env ruby -w
require_relative '../../helper'
require 'discoteq/chef/service_query'

# Test Chef::ServiceQuery edge case behaviour
class TestChefServiceQuery < Minitest::Test
  def test_opts_must_be_hash
    assert_raises(ArgumentError) do
      Discoteq::Chef::ServiceQuery.new(:foo, :not_a_hash)
    end
  end

  def test_opts_must_include_query
    assert_raises(ArgumentError)  do
      Discoteq::Chef::ServiceQuery.new(:foo, 'not-query' => 'bar')
    end
  end

  def test_responds_with_nodes
    expected = [{'hostname' => 'myface-001.example.net'}]
    stub(Discoteq::Chef::Nodes).find {expected}
    q = Discoteq::Chef::ServiceQuery.new(:foo, 'query' => 'bar')
    assert_equal q.records, expected
  end

  def test_passes_query_and_attributes_to_nodes
    # Arrange
    stub(Discoteq::Chef::Nodes).find {[:foo]}
    q = Discoteq::Chef::ServiceQuery.new(
      :foo,
      'query' => 'expected-query')
    # Act
    q.records
    # Assert
    assert_received(Discoteq::Chef::Nodes) do |n|
      n.find('expected-query', 'hostname' => 'fqdn')
    end
  end
end
