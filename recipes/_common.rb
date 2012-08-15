include_recipe "python::pip"

group node['buildbot']['group']

user node['buildbot']['user'] do
  comment "Buildbot user"
  system true
  shell "/bin/false"
end

