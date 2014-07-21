#!/usr/bin/env ruby -w
require_relative '../helper'
require 'discoteq/config'

# Test Config edge case behaviour
class TestConfig < Minitest::Test
  def test_initially_unprepared
    refute Discoteq::Config.new.prepared?
  end

  def test_modification_leaves_unprepared
    # Arrange
    cfg = Discoteq::Config.new
    cfg.prepare!
    assert cfg.prepared?, 'was unprepared after #prepare! was called'
    # Act
    cfg['foo'] = 'bar'
    # Assert
    refute cfg.prepared?, 'was prepared before #prepare! was called'
  end

  # when running #prepare!
  def test_prepare_leaves_prepared
    # Arrange
    cfg = Discoteq::Config.new
    refute cfg.prepared?, 'was prepared before #prepare! was called'
    # Act
    cfg.prepare!
    # Assert
    assert cfg.prepared?, 'was unprepared after #prepare! was called'
  end

  def test_prepare_configures_chef_if_present
    # Arrange
    cfg = Discoteq::Config.new
    cfg['chef'] = {}
    # Discoteq::Chef::Config.new(self['chef'])
    refute cfg.prepared?, 'was prepared before #prepare! was called'
    # Act
    cfg.prepare!
    # Assert
    assert cfg.prepared?, 'was unprepared after #prepare! was called'
  end

  def test_prepare_does_nothing_when_prepared
    skip
  end

  def test_prepare_ignores_chef_if_absent
    skip
  end
end
