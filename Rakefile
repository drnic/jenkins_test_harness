ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __FILE__)

require "rubygems"
require "bundler"
Bundler.setup(:default, :test, :development)

require "bundler/gem_tasks"

require "rake/dsl_definition"
require "rake"
require "rspec/core/rake_task"

require "jenkins_test_harness"

namespace :jenkins do
  def server; @server ||= JenkinsTestHarness::Server.new(port: 3333, daemon: true); end

  desc "Start daemonized Jenkins server for running integration tests"
  task :start do
    server.start
  end

  desc "Block until daemonized Jenkins server has full started"
  task :wait_til_started do
    server.wait_for_server_start
  end

  desc "Stop daemonized Jenkins server"
  task :stop do
    server.stop
  end
end
    
if defined?(RSpec)
  namespace :spec do
    desc "Run Unit Tests"
    unit_rspec_task = RSpec::Core::RakeTask.new(:unit) do |t|
      t.pattern = "spec/unit/**/*_spec.rb"
      t.rspec_opts = %w(--format documentation --color)
    end

    desc "Run Integration Tests"
    RSpec::Core::RakeTask.new(:integration) do |t|
      t.pattern = "spec/integration/**/*_spec.rb"
      t.rspec_opts = %w(--format documentation --color)
    end
  end

  desc "Run tests; assumes jenkins server is running"
  task :spec => %w(spec:unit spec:integration)

  task :default => "spec:unit"
end

