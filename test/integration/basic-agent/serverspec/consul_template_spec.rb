require_relative '../../helper_spec.rb'

describe 'Consul template' do
  if %w(ubuntu).include? os[:family]
    describe service('consul-template') do
      it { should be_enabled }
      it { should be_running }
    end
  end

  describe file('/etc/consul-template.conf') do
    it { should be_file }
    it { should be_mode 640 }
    it { should be_owned_by 'consul' }
    it { should be_grouped_into 'consul' }
  end

  describe file('/etc/haproxy/haproxy.cfg') do
    its(:content) { should contain "# First template  : Ansible managed, Don't modify manually\n# Second template : consul template" }
  end
end

# TODO: check consul template logs for keywords
# TODO: check haproxy logs that it was reloaded