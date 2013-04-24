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

def stub_jenkins(options={})
  base_uri = options.delete(:base_uri) || "http://127.0.0.1:8080"
  FakeWeb.clean_registry
  if options[:allow_host] # e.g. http://127.0.0.1
    FakeWeb.allow_net_connect = %r[^#{base_uri}]
  end
  # assume the root url will be pinged to test for connection
  FakeWeb.register_uri(:get, "#{base_uri}/", :status => 200)
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

