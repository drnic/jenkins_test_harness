describe JenkinsTestHarness::JobBuild do
  before do
    stub_jenkins
    JenkinsTestHarness::Api.connect(valid_config)
  end
  subject { JenkinsTestHarness::JobBuild.new("Test", 10) }

  describe "has status" do
    it "blue => success" do
      status_color = { color: "blue" }
      stub_jenkins_api(:get, "/job/Test/api/json", body: status_color.to_json)
      subject.status.should == "success"
    end

    it "yellow => unstable" do
      status_color = { color: "yellow" }
      stub_jenkins_api(:get, "/job/Test/api/json", body: status_color.to_json)
      subject.status.should == "unstable"
    end
  end

  describe "console output" do
    it "one page" do
      path = "/job/Test/10/logText/progressiveText?start=0"
      stub_jenkins_api(:get, path, body: "one page only",
        "x-text-size" => "10", 'x-more-data' => "false")
      subject.console_output.should == "one page only"
    end

    it "two pages" do
      path = "/job/Test/10/logText/progressiveText?start=0"
      stub_jenkins_api(:get, path, body: "first page,",
        "x-text-size" => "10", 'x-more-data' => "true")
      path = "/job/Test/10/logText/progressiveText?start=10"
      stub_jenkins_api(:get, path, body: "second page",
        "x-text-size" => "11", 'x-more-data' => "false")
      subject.console_output.should == "first page,second page"
    end
  end
end