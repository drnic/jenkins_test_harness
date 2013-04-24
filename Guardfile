guard 'rspec' do
  watch(%r{^spec/unit/.+_spec\.rb$})
  watch(%r{^lib/jenkins_test_harness/(.+)\.rb$})     { |m| "spec/unit/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

