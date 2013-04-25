describe JenkinsTestHarness::Api do
  before do
    stub_jenkins
    stub_jenkins_jobs(["Test Job Name"])
  end
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
