#
# Cookbook Name:: hipsnip-jetty
# Recipe:: default
#
# Copyright 2012-2013, HipSnip Limited
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

include_recipe 'java'

require 'fileutils'

################################################################################
# Guess node['jetty']['contexts'] attribute if not set based on the given jetty
#  version in node['jetty']['version']
#  Reason why: webapps contexts are in /contexts in Jetty 7/8
#  and in Jetty 9, there are in alongs with the war file (in /webapps)

node.set['jetty']['webapps'] = "#{node['jetty']['home']}/webapps"
version = 8
if /^9.*/.match(node['jetty']['version'])
  version = 9
  node.set['jetty']['contexts'] = node['jetty']['webapps']
else
  node.set['jetty']['contexts'] = "#{node['jetty']['home']}/contexts"
end

################################################################################
# Set node attributes

node.set['jetty']['download']  = "#{node['jetty']['directory']}/jetty-distribution-#{node['jetty']['version']}.tar.gz"
node.set['jetty']['extracted'] = "#{node['jetty']['directory']}/jetty-distribution-#{node['jetty']['version']}"
node.set['jetty']['args'] =  (node['jetty']['args'] + ["-Djetty.port=#{node['jetty']['port']}", "-Djetty.logs=#{node['jetty']['logs']}"]).uniq

################################################################################
# Create user and group

user node['jetty']['user'] do
  home  node['jetty']['home']
  shell '/bin/false'
  system true
  action :create
end

group node['jetty']['group'] do
  members "jetty"
  system true
  action :create
end

################################################################################
# Create few directories for jetty


[node['jetty']['home'], node['jetty']['contexts'], node['jetty']['webapps'], "#{node['jetty']['home']}/lib","#{node['jetty']['home']}/resources"].each do |d|
  directory d do
    owner node['jetty']['user']
    group node['jetty']['group']
    mode  '755'
  end
end


################################################################################
# Download and install Jetty

service 'jetty' do
  action :nothing
end

remote_file node['jetty']['download'] do
  source   node['jetty']['link']
  checksum node['jetty']['checksum']
  mode     0644
end


ruby_block 'Extract Jetty' do
  block do
    Chef::Log.info "Extracting Jetty archive #{node['jetty']['download']} into #{node['jetty']['directory']}"
    `tar xzf #{node['jetty']['download']} -C #{node['jetty']['directory']}`
    raise "Failed to extract Jetty package" unless File.exists?(node['jetty']['extracted'])
  end

  action :create

  not_if do
    File.exists?(node['jetty']['extracted'])
  end
end


ruby_block 'Copy Jetty lib files' do
  block do
    Chef::Log.info "Copying Jetty lib files into #{node['jetty']['home']}"
    FileUtils.cp_r File.join(node['jetty']['extracted'], 'lib', ''), node['jetty']['home']
    FileUtils.chown_R(node['jetty']['user'],node['jetty']['group'],File.join(node['jetty']['home'], 'lib', ''))
    raise "Failed to copy Jetty libraries" if Dir[File.join(node['jetty']['home'], 'lib', '*')].empty?
  end

  action :create

  only_if do
    Dir[File.join(node['jetty']['home'], 'lib', '*')].empty?
  end
end


ruby_block 'Copy Jetty start.jar' do
  block do
    Chef::Log.info "Copying Jetty start.jar into #{node['jetty']['home']}"

    FileUtils.cp File.join(node['jetty']['extracted'], 'start.jar'), node['jetty']['home']
    FileUtils.chown_R(node['jetty']['user'],node['jetty']['group'],File.join(node['jetty']['home'], 'start.jar'))
    raise "Failed to copy Jetty start.jar" unless File.exists?(File.join(node['jetty']['home'], 'start.jar'))
  end

  action :create

  not_if do
    File.exists?(File.join(node['jetty']['home'], 'start.jar'))
  end
end

#################################################################################
# Init script and setup service

if node['jetty']['syslog']['enable']
  template '/etc/init.d/jetty' do
    source "jetty-#{version}.sh.erb"
    mode   '544'
    action :create
  end
else
  ruby_block 'Copy Jetty init file (jetty.sh)' do
    block do
      Chef::Log.info "Copying Jetty init file (jetty.sh) into /etc/init.d/ folder"

      FileUtils.cp File.join(node['jetty']['extracted'], 'bin/jetty.sh'), "/etc/init.d/jetty"
      raise "Failed to copy Jetty init file (jetty.sh)" unless File.exists?("/etc/init.d/jetty")
    end

    action :create

    not_if do
      File.exists?("/etc/init.d/jetty")
    end
  end
end

service "jetty" do
  action :enable
end

################################################################################
# Jetty Config

directory "/etc/jetty" do
  mode '755'
  owner node['jetty']['user']
  group node['jetty']['group']
end

directory "#{node['jetty']['home']}/start.d" do
  mode '755'
  owner node['jetty']['user']
  group node['jetty']['group']
end

link "#{node['jetty']['home']}/etc" do
  to "/etc/jetty"
  owner node['jetty']['user']
  group node['jetty']['group']
end

ruby_block 'Copy Jetty config files' do
  block do
    Chef::Log.info "Copying Jetty config files into #{node['jetty']['home']}/etc"

    FileUtils.cp_r File.join(node['jetty']['extracted'], 'etc', ''), node['jetty']['home']
    FileUtils.remove_file(File.join(node['jetty']['home'], 'etc', 'jetty.conf'), true)
    FileUtils.chown_R(node['jetty']['user'],node['jetty']['group'],File.join(node['jetty']['home'], 'etc', ''))
    raise "Failed to copy Jetty config files" if Dir[File.join(node['jetty']['home'], 'etc', '*')].empty?
  end

  action :create

  only_if do
    Dir[File.join(node['jetty']['home'], 'etc', '*')].empty?
  end
end

template '/etc/default/jetty' do
  source 'jetty.default.erb'
  mode   '644'
  owner node['jetty']['user']
  group node['jetty']['group']
  notifies :restart, "service[jetty]"
  action :create
end


template "/etc/jetty/jetty.conf" do
  source "jetty.conf.erb"
  mode   '644'
  owner node['jetty']['user']
  group node['jetty']['group']
  notifies :restart, "service[jetty]"
end

if node['jetty']['start_ini']['custom']
  template "#{node['jetty']['home']}/start.ini" do
    source "start.ini.erb"
    mode   '644'
    owner node['jetty']['user']
    group node['jetty']['group']
    notifies :restart, "service[jetty]"
  end
else
  cookbook_file "#{node['jetty']['home']}/start.ini" do
    source "jetty-#{version}-start.ini"
    mode   '644'
    owner node['jetty']['user']
    group node['jetty']['group']
    notifies :restart, "service[jetty]"
  end
end

################################################################################
# Logs

# folder for logs mandatory at least for the request logs
directory node['jetty']['logs'] do
  mode '755'
  owner node['jetty']['user']
  group node['jetty']['group']
end

template File.join(node['jetty']['home'], 'resources/jetty-logging.properties') do
  source 'jetty-logging.properties.erb'
  mode   '644'
  owner node['jetty']['user']
  group node['jetty']['group']
  notifies :restart, "service[jetty]"
  action :create
end
