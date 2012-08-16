# Needed to install Python packages
include_recipe "python::pip"

# Add user and group for Buildbot
group node['buildbot']['group']

user node['buildbot']['user'] do
  comment "Buildbot user"
  gid node['buildbot']['group']
  system true
  shell "/bin/false"
end

# Install the system's dependencies
packages = value_for_platform(
  ["centos", "redhat", "suse", "fedora" ] => {
    "default" => %w{ git python-devel }
  },
  ["ubuntu", "debian"] => {
    "default" => %w{ git-core python-dev }
  }
)

packages.each do |pkg|
  package pkg
end
