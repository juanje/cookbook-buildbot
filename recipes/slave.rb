# Cookbook Name:: buildbot
# Recipe:: slaves
#
# Copyright 2012, Juanje Ojeda <juanje.ojeda@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "buildbot::_common"

slave_basedir = ::File.join(node['buildbot']['slave']['deploy_to'],
                            node['buildbot']['slave']['basedir'])
options = node['buildbot']['slave']['options']
host = node['buildbot']['master']['host']
port = node['buildbot']['slave']['port']
slave_name = node['buildbot']['slave']['name']
password = node['buildbot']['slave']['password']


# Install the Python package
python_pip "buildbot-slave" do
  action :install
end


# Deploy the Slave
directory node['buildbot']['slave']['deploy_to'] do
  owner node['buildbot']['user']
  group node['buildbot']['group']
  mode "0755"
  action :create
end

execute "Start the slave" do
  command "buildslave restart #{slave_basedir}"
  user node['buildbot']['user']
  group node['buildbot']['group']
  action :nothing
end

execute "Create slave" do
  command "buildslave create-slave #{options} #{slave_basedir} #{host}:#{port} #{slave_name} #{password}"
  user node['buildbot']['user']
  group node['buildbot']['group']
  notifies :run, resources(:execute => "Start the slave")
end

