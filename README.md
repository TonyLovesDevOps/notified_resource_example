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
```

The two cookbooks are identical in all ways except that notify-success includes compat_resource 12.9.1 in metadata.rb/Berksfile while notify-failure includes 12.10.5
```
# notify-success/Berksfile:
cookbook 'compat_resource', '= 12.9.1'

# notify-failure/Berksfile:
cookbook 'compat_resource', '= 12.10.5'
```
