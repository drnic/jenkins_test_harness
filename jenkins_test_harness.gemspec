# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jenkins_test_harness/version'

Gem::Specification.new do |spec|
  spec.name          = "jenkins_test_harness"
  spec.version       = JenkinsTestHarness::VERSION
  spec.authors       = ["Dr Nic Williams"]
  spec.email         = ["drnicwilliams@gmail.com"]
  spec.description   = %q{Run integration tests on Jenkins jobs to ensure they are behaving as expected.}
  spec.summary       = %q{Run integration tests on Jenkins jobs to ensure they are behaving as expected.
    Also allows TDD (test-driven development) to be used for the authoring of Jenkins jobs.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "jenkins_api_client", "~> 0.10.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "fakeweb"
  spec.add_development_dependency "jenkins-war", "~> 1.475"
end
