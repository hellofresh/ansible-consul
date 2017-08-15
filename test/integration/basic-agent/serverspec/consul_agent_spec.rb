require_relative '../../helper_spec.rb'

describe 'consul agent' do

  if %w(ubuntu).include? os[:family]
    describe service('consul') do
      it { should be_enabled }
      it { should be_running }
    end
  end

  describe user('consul') do
    it { should exist }
    it { should belong_to_group 'consul' }
  end

  %w(/opt/consul /opt/consul/bin /opt/consul/data /etc/consul.d).each do |dir|
    describe file(dir) do
      it { should be_directory }
      it { should be_owned_by('consul') }
    end
  end

  describe file('/etc/consul.conf') do
    it { should be_file }
    its (:content) { should match /"server": true/ }
  end

  describe file('/var/log/consul/consul-agent.log') do
    it { should be_file }
    it { should be_owned_by('consul') }
    its (:content) { should contain 'New leader elected:' }
  end

  describe port(8300) do
    it { should be_listening.with('tcp') }
  end
  describe port(8301) do
    it { should be_listening.with('tcp') }
  end

  describe port(8500) do
    it { should be_listening.on('127.0.0.1').with('tcp') }
  end

  describe 'UI should be disabled' do
    describe command 'curl -s -I http://127.0.0.1:8500/ui/' do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain 'HTTP/1.1 404 Not Found' }
    end
  end

end
