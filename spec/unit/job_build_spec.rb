describe JenkinsTestHarness::JobBuild do
  before do
    stub_jenkins
    JenkinsTestHarness::Api.connect(valid_config)
  end
  subject { JenkinsTestHarness::JobBuild.new("Test Job Name", 10) }

  describe "has status" do
    it "blue => success" do
      status_color = { color: "blue" }
      stub_jenkins_api(:get, "/job/Test%20Job%20Name/api/json", body: status_color.to_json)
      subject.status.should == "success"
    end

    it "yellow => unstable" do
      status_color = { color: "yellow" }
      stub_jenkins_api(:get, "/job/Test%20Job%20Name/api/json", body: status_color.to_json)
      subject.status.should == "unstable"
    end
  end

end