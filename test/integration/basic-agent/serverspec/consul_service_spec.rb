require_relative '../../helper_spec.rb'

describe 'superssh service (localport option)' do
  describe 'definition by name' do
    describe command 'curl -s -v http://127.0.0.1:8500/v1/catalog/service/superssh-testing' do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain '"ServiceName":"superssh-testing"' }
      its(:stdout) { should match /"ServiceTags":\[.*"env:testing".*/ }
      its(:stdout) { should match /"ServiceTags":\[.*"WEIGHT:77".*/ }
      its(:stdout) { should match /"ServiceTags":\[.*"test".*/ }
      its(:stdout) { should contain '"ServicePort":22' }
    end
  end

  describe 'health is passing' do
    describe command 'curl -s -v http://127.0.0.1:8500/v1/health/service/superssh-testing' do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain '"Service":"superssh-testing"' }
      its(:stdout) { should contain '"Status":"passing"' }
    end
  end

  describe 'definition by key should be empty' do
    describe command 'curl -s -v http://127.0.0.1:8500/v1/catalog/service/superssh' do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match '\[\]' }
    end
  end

  describe 'localport 2222 is open by haproxy' do
    describe port(2222) do
      it { should be_listening.on('127.0.0.1').with('tcp') }
    end
  end

  describe 'ssh is working on 2222' do
    describe command 'echo X | nc 127.0.0.1 2222 2>&1 | grep SSH' do
      its(:exit_status) { should eq 0 }
    end
  end
end

describe 'superdb service (A failing service)' do
  describe 'definition' do
    describe command 'curl -s -v http://127.0.0.1:8500/v1/catalog/service/superdb' do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain '"ServiceName":"superdb"' }
      its(:stdout) { should match /"ServiceTags":\[.*"userdb".*/ }
      its(:stdout) { should match /"ServiceTags":\[.*"v1\.2".*/ }
      its(:stdout) { should match /"ServiceTags":\[.*"env:testing".*/ }
      its(:stdout) { should contain '"ServicePort":2122' }
    end
  end

  describe 'health is failing' do
    describe command 'curl -s -v http://127.0.0.1:8500/v1/health/service/superdb' do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain '"Service":"superdb"' }
      its(:stdout) { should contain '"Status":"(warning|critical)"' }
    end
  end

  describe 'localport 2122 is open by haproxy' do
    describe port(2122) do
      it { should be_listening.on('127.0.0.1').with('tcp') }
    end
  end
end

describe 'superapp service (a non advertised service)' do
  describe 'definition should not exist' do
    describe command 'curl -s -v http://127.0.0.1:8500/v1/catalog/service/superapp' do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match '\[\]' }
    end
  end

  describe 'localport 9999 is open by haproxy' do
    describe port(9999) do
      it { should be_listening.on('127.0.0.1').with('tcp') }
    end
  end
end

describe 'hellofresh service (normal port option)' do
  describe 'definition' do
    describe command 'curl -s -v http://127.0.0.1:8500/v1/catalog/service/hellofresh' do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain '"ServiceName":"hellofresh"' }
      its(:stdout) { should contain '"ServiceAddress":"127.0.0.1"' }
      its(:stdout) { should contain '"ServicePort":80' }
    end
  end

  describe 'health is passing' do
    describe command 'curl -s -v http://127.0.0.1:8500/v1/health/service/hellofresh' do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain '"Service":"hellofresh"' }
      its(:stdout) { should contain '"Status":"passing"' }
    end
  end

  describe 'localport 8080 is open by haproxy' do
    describe port(8080) do
      it { should be_listening.on('127.0.0.1').with('tcp') }
    end
  end

  describe 'HAProxy stats unix-connect working' do
    describe command "echo 'show stat' | socat unix-connect:/var/lib/haproxy/stats.sock stdio" do
      its(:exit_status) { should eq 0 }
    end
  end

  describe 'HAProxy server backend should be listed and up' do
    let(:pre_command) { 'sleep 2' }
    describe command "echo 'show stat' | socat unix-connect:/var/lib/haproxy/stats.sock stdio | grep hellofresh-testing,hellofresh | grep UP" do
      its(:exit_status) { should eq 0 }
    end
  end

  describe 'hellofresh backend should have default weight' do
    describe command 'echo "get weight hellofresh-testing/`cat /etc/haproxy/haproxy.cfg  | grep "server hellofresh" | awk \'{print $2}\'`" | socat unix-connect:/var/lib/haproxy/stats.sock stdio  | grep 100' do
      its(:stdout) { should contain '100 \(initial 100\)'}
    end
  end

  describe 'superssh-testing backend should have set weight' do
    describe command 'echo "get weight superssh-testing/`cat /etc/haproxy/haproxy.cfg  | grep "server superssh-testing" | awk \'{print $2}\'`" | socat unix-connect:/var/lib/haproxy/stats.sock stdio  | grep 77' do
      its(:stdout) { should contain '77 \(initial 77\)'}
    end
  end

  describe 'Curl hellofresh upstream service is working on 80' do
    describe command 'curl http://127.0.0.1:80' do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain 'Thank you for using nginx' }
    end
  end

  describe 'Curl hellofresh service is working on 8080' do
    describe command 'curl http://127.0.0.1:8080' do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain 'Thank you for using nginx' }
    end
  end
end
