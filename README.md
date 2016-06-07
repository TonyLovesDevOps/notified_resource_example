These cookbooks show that resource notifications work differently when different versions of the compat_resource cookbook are loaded.

To test:
```
$ cd notify-success
$ kitchen test
# tests pass

$ cd notify-failure
$ kitchen test
# tests fail
```

notify-success and notify-failure create a directory with an owner that is lazy-loaded using a ruby_block resource:

```
# recipes/default.rb
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
```

The two cookbooks are identical in all ways except that notify-success includes compat_resource 12.9.1 in metadata.rb/Berksfile while notify-failure includes 12.10.5
```
# notify-success/Berksfile:
cookbook 'compat_resource', '= 12.9.1'

# notify-failure/Berksfile:
cookbook 'compat_resource', '= 12.10.5'
```
