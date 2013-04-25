# Copyright (c) 2012-2013 Stark & Wayne, LLC

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", __FILE__)

require "rubygems"
require "bundler"
Bundler.setup(:default, :test)

$:.unshift(File.expand_path("../../lib", __FILE__))

require "rspec/core"
require "fakeweb"

# for the #sh helper
require "rake"
require "rake/file_utils"

require "jenkins_test_harness"

Dir[File.dirname(__FILE__) + '/support/*'].each{|path| require path}

def valid_config
  {
    "server_ip"   => "valid.host",
    "server_port" => "8080",
    "username"    => "valid",
    "password"    => "valid",
    "debug"       => "true"
  }
end

def bad_credentials
  valid_config.merge("password" => "bad")
end

def valid_base_jenkins_uri; "http://valid:valid@valid.host:8080"; end

def stub_jenkins(options={})
  bad_password_base_uri = "http://valid:bad@valid.host:8080"
  FakeWeb.clean_registry
  if options.delete(:allow_host) || options.delete("allow_host")
    FakeWeb.allow_net_connect = %r[^#{valid_base_uri}]
  else
    FakeWeb.allow_net_connect = false
  end

  FakeWeb.register_uri(:get, "#{bad_password_base_uri}/api/json", status: 401)

  stub_jenkins_jobs(["Test Job Name", "Test"])
end

def stub_jenkins_jobs(names)
  jobs = {
    "jobs" => names.map { |name| {"name" => name} }
  }
  FakeWeb.register_uri(:get, "#{valid_base_jenkins_uri}/api/json", status: 200, body: jobs.to_json)
end

def stub_jenkins_api(method, path, options={})
  options[:status] ||= 200
  valid_base_uri = "http://valid:valid@valid.host:8080"
  FakeWeb.register_uri(method, "#{valid_base_uri}#{path}", options)
end

def upload_server_job(job_filename)
  job_file = File.read(spec_asset("jobs/#{job_filename}"))
end

def spec_asset(filename)
  File.expand_path("../assets/#{filename}", __FILE__)
end

def files_match(filename, expected_filename)
  file = File.read(filename)
  expected_file = File.read(expected_filename)
  file.should == expected_file
end

def setup_home_dir
  home_dir = File.expand_path("../../tmp/home", __FILE__)
  FileUtils.rm_rf(home_dir)
  FileUtils.mkdir_p(home_dir)
  ENV['HOME'] = home_dir
end

# returns the file path to a file
# in the fake $HOME folder
def home_file(*path)
  File.join(ENV['HOME'], *path)
end

def get_tmp_file_path(content)
  tmp_file = File.open(File.join(Dir.mktmpdir, "tmp"), "w")
  tmp_file.write(content)
  tmp_file.close

  tmp_file.path
end

RSpec.configure do |c|
  c.before(:each) do
    setup_home_dir
  end

  c.color_enabled = true
end
