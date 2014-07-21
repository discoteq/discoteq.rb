require 'pathname'
lib_path = Pathname.new(__FILE__).join('../../../lib').expand_path.to_s
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include? lib_path

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require 'rr'
