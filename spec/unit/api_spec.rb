describe JenkinsTestHarness::Api do
  before { stub_jenkins("base_uri" => "http://valid:valid@valid.host:8080") }
  let(:valid_credentials) do
    {
      "server_ip"   => "valid.host",
      "server_port" => "8080",
      "username"    => "valid",
      "password"    => "valid",
    }
  end
  it "attempts to validate Jenkins credentials by connecting" do
    JenkinsTestHarness::Api.connect(valid_credentials)
  end
  it "provides JenkinsApi::Client for api access" do
    JenkinsTestHarness::Api.connect(valid_credentials)
    JenkinsTestHarness::Api.api.should be_is_a(JenkinsApi::Client)
  end
end
