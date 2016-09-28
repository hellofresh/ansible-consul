require 'spec_helper'

describe 'consul UI' do

    describe command "curl -s  http://127.0.0.1:8500/ui/ | grep '<title>'" do 
        its(:exit_status) { should eq 0 }
        its(:stdout) { should contain "<title>Consul by HashiCorp</title>" }
    end

end
