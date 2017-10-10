require_relative '../../helper_spec.rb'


describe 'hellofresh service' do
  describe command 'curl -s -v http://127.0.0.1:8500/v1/health/service/hellofresh' do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should contain '"ServiceName":"hellofresh"' }
    its(:stdout) { should match /"Tags":\[.*"test".*/ }
    its(:stdout) { should match /"Tags":\[.*"v1\.1\.5".*/ }
    its(:stdout) { should match /"Tags":\[.*"WEIGHT:77".*/ }
    its(:stdout) { should match /"Tags":\[.*"staging".*/ }
    its(:stdout) { should contain '"Port":80' }
    its(:stdout) { should contain '"Status":"passing"' }
  end
end

describe 'superssh-different-name service' do
  describe command 'curl -s -v http://127.0.0.1:8500/v1/health/service/superssh-different-name' do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should contain '"Service":"superssh-different-name"' }
    its(:stdout) { should match /"Tags":\[.*"staging".*/ }
    its(:stdout) { should match /"Tags":\[.*"test".*/ }
    its(:stdout) { should match /"Tags":\[.*"v2\.1\.2".*/ }
    its(:stdout) { should contain '"Port":22' }
    its(:stdout) { should contain '"Status":"passing"' }
  end
end

describe 'superdb' do
  describe command 'curl -s -v http://127.0.0.1:8500/v1/health/service/superdb' do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should contain '"Service":"superdb"' }
    its(:stdout) { should match /"Tags":\[.*"staging".*/ }
    its(:stdout) { should match /"Tags":\[.*"test".*/ }
    its(:stdout) { should match /"Tags":\[.*"v3\.9\.2".*/ }
    its(:stdout) { should contain '"Port":2122' }
    its(:stdout) { should contain '"Status":"(warning|critical)"' }
  end
end
