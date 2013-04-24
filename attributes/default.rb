#
# Cookbook Name:: hipsnip-jetty
# Recipe:: default
#
# Copyright 2012-2013, HipSnip Limited
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
default['jetty']['user'] = 'jetty'
default['jetty']['group'] = 'jetty'
default['jetty']['home'] = '/usr/share/jetty'
default['jetty']['port'] = 8080
# The default arguments to pass to jetty.
default['jetty']['args'] = "jetty.port=#{node['jetty']['port']}"
default['jetty']['logs'] = ''
# Extra options to pass to the JVM
default['jetty']['java_options'] = ''

########################################################################
# Do not touch these attributes except if you really know what you doing
default['jetty']['contexts']      = ""
default['jetty']['webapps']       = "#{node['jetty']['home']}/webapps"
########################################################################

# set of paths of jetty configuration files relative to jetty home directory.
# e.g: ['etc/jetty-webapps.xml', 'etc/jetty-http.xml']
default['jetty']['add_confs'] = []

default['jetty']['version']		= '9.0.2.v20130417'
default['jetty']['link']      = 'http://eclipse.org/downloads/download.php?file=/jetty/stable-9/dist/jetty-distribution-9.0.2.v20130417.tar.gz&r=1'
default['jetty']['checksum']  = '6ab0c0ba4ff98bfc7399a82a96a047fcd2161ae46622e36a3552ecf10b9cddb9' # SHA256

default['jetty']['directory'] = '/usr/local/src'
default['jetty']['download']  = "#{node['jetty']['directory']}/jetty-distribution-#{node['jetty']['version']}.tar.gz"
default['jetty']['extracted'] = "#{node['jetty']['directory']}/jetty-distribution-#{node['jetty']['version']}"

# SEVERE ERROR (highest value) WARNING INFO CONFIG FINE FINER FINEST (lowest value)
default['jetty']['log']['level']  = 'INFO'
default['jetty']['log']['class'] = 'org.eclipse.jetty.util.log.StdErrLog'

#default['jetty']['config']['requestHeaderSize'] = 8192 #10000