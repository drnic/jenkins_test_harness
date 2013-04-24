source 'https://rubygems.org'

# Specify your gem's dependencies in jenkins_test_harness.gemspec
gemspec

# TODO: This is temporary until the following PR is merged and gem released:
# https://github.com/arangamani/jenkins_api_client/pulls
gem "jenkins_api_client", github: "drnic/jenkins_api_client", branch: "console_output"

group :test do
  gem "awesome_print"
  gem "rb-fsevent", "~> 0.9.1"
  gem "guard-rspec"
end
