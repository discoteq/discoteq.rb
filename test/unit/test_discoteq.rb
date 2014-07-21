#!/usr/bin/env ruby -w
require_relative 'helper'
require 'minitest/autorun'

require 'discoteq'

# Test Discoteq edge case behaviour
class TestDiscoteq < Minitest::Test
  def setup
    Discoteq.config = nil
  end

  def test_service_map_sans_query_map_fails
    assert_raises ArgumentError do
      Discoteq.service_map
    end
  end

  def test_service_map_touches_everything
    Discoteq.config = {'query_map' => []}
    actual = Discoteq.service_map
    expected = {}
    assert_equal expected, actual
  end

  def test_default_config
    actual = Discoteq.config
    expected = {}
    assert_equal expected, actual
  end

  def test_config_assignment
    Discoteq.config = {'foo' => 'bar'}
    actual = Discoteq.config
    expected = {'foo' => 'bar'}
    assert_equal expected, actual
  end
end
