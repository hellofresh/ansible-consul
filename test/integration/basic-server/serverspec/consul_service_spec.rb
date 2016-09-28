require_relative '../../helper_spec.rb'

describe 'consul service' do

    describe command "curl -s  http://127.0.0.1:8500/v1/catalog/service/consul -v" do
        its(:exit_status) { should eq 0 }
        its(:stdout) { should contain '"ServiceName":"consul"' }
    end

end
