folder_owner = nil

ruby_block "get_folder_uid" do
  block do
    folder_owner = "vagrant"
  end
  action :nothing
end

directory "/tmp/foo" do
  owner lazy { folder_owner } # lazy means that the variable value is looked up at converge vs. compile
  notifies :run, "ruby_block[get_folder_uid]", :before
end
