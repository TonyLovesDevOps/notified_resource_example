

ruby_block "get_folder_owner" do
  block do
    Chef::Log.warn("Begin get_folder_owner ruby_block")
    node.run_state['directory_owner'] = 'vagrant'
    Chef::Log.warn("End get_folder_owner ruby_block")
  end
  action :nothing
end

directory "/tmp/foo" do
  owner lazy { node.run_state['directory_owner'] } # lazy means that the variable value is looked up at converge vs. compile
  notifies :run, "ruby_block[get_folder_owner]", :before
end
