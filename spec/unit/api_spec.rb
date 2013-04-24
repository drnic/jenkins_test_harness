describe JenkinsTestHarness::Api do
  before { stub_jenkins }
  let(:valid_config) do
    {
      "server_ip"   => "valid.host",
      "server_port" => "8080",
      "username"    => "valid",
      "password"    => "valid",
    }
  end
  let(:bad_credentials) { valid_config.merge("password" => "bad") }
  it "attempts to validate Jenkins credentials by connecting" do
    JenkinsTestHarness::Api.connect(valid_config)
  end
  it "fails to connect with bad credentials" do
    expect { JenkinsTestHarness::Api.connect(bad_credentials) }.
      to raise_error(JenkinsApi::Exceptions::UnautherizedException)
  end
  it "provides JenkinsApi::Client for api access" do
    JenkinsTestHarness::Api.connect(valid_config)
    JenkinsTestHarness::Api.api.should be_is_a(JenkinsApi::Client)
  end
end
