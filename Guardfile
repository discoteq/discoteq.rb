guard :minitest do
  watch(%r{^test/unit/(.*)\/?test_(.*)\.rb$})
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/unit/#{m[1]}test_#{m[2]}.rb" }
#  watch(%r{^test/test_helper\.rb$})      { 'test' }
end

# guard :rubocop do
#   watch(%r{.+\.rb$})
#   watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
# end
