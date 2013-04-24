describe JenkinsTestHarness::JobHarness do
  before do
    stub_jenkins
    JenkinsTestHarness::Api.connect(valid_config)

    # expect target job's config to be downloaded
    stub_jenkins_api(:get, "/job/Test%20Job%20Name/config.xml", body: "<job>config</job>")

    # expect cloned job to be created using target job's config
    stub_jenkins_api(:post, "/createItem?name=Test%20Job%20Name%20-%20Clone", :status => 302)

    stub_jenkins_jobs(["Test Job Name", "Test Job Name - Clone"])
  end
  subject { JenkinsTestHarness::JobHarness.new("Test Job Name") }

  it "runs a job: creates clone, builds it, destroys it" do
    # expect cloned job to be built; not target job
    stub_jenkins_api(:post, "/job/Test%20Job%20Name%20-%20Clone/build", :status => 302)

    build_job = subject.build
    build_job.should be_instance_of(JenkinsTestHarness::JobBuild)
    build_job.job_name.should == "Test Job Name - Clone"
    build_job.job_build_number.should == 1
  end

  it "runs a parameterized job: creates clone, builds it, destroys it" do
    # expect cloned job to be built; not target job
    stub_jenkins_api(:post, "/job/Test%20Job%20Name%20-%20Clone/buildWithParameters", :status => 302)

    build_job = subject.build({"param1" => "value1"})
    build_job.should be_instance_of(JenkinsTestHarness::JobBuild)
    build_job.job_name.should == "Test Job Name - Clone"
    build_job.job_build_number.should == 1
  end
end