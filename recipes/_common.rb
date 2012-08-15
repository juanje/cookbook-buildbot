include_recipe "python::pip"

group node['buildbot']['group']

user node['buildbot']['user'] do
  comment "Buildbot user"
  gid node['buildbot']['group']
  system true
  shell "/bin/false"
end

