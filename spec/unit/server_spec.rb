describe JenkinsTestHarness::Server do
  subject { JenkinsTestHarness::Server.new(port: 3333) }
  it "knows its Jenkins server version" do
    subject.version.should =~ /^1\./
  end
  it "has defaults port" do
    JenkinsTestHarness::Server.new.port.should == 3001
  end
  it "defaults control port from port" do
    subject.control.should == 3334
  end
  it "runs jenkins server & stops it" do
    subject.start # blocks until running
    subject.should be_running
    subject.stop
  end
end