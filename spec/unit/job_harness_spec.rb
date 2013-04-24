describe JenkinsTestHarness::JobHarness do
  before do
    stub_jenkins
    JenkinsTestHarness::Api.connect(valid_config)
  end
  subject { JenkinsTestHarness::JobHarness.new("Test Job Name") }

  xit "runs a job: creates clone, builds it, destroys it" do
    subject.build
  end

  xit "runs a parameterized job: creates clone, builds it, destroys it" do
    subject.build({"param1" => "value1"})
  end
end