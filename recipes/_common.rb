include_recipe "python::pip"

group node['buildbot']['group']

user node['buildbot']['user'] do
  comment "Buildbot user"
  gid node['buildbot']['group']
  system true
  shell "/bin/false"
end

packages = value_for_platform(
  ["centos", "redhat", "suse", "fedora" ] => {
    "default" => %w{ git python-devel }
  },
  ["ubuntu", "debian"] => {
    "default" => %w{ git python-dev }
  }
)

packages.each do |pkg|
  package pkg
end
