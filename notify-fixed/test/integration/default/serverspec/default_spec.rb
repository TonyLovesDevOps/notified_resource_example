require 'serverspec'
set :backend, :exec

describe file('/tmp/foo') do
  it { should be_directory }
  it { should be_owned_by 'vagrant' }
end
