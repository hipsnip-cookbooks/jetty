## Cookbook Name:: hipsnip-jetty
## Recipe:: rhel_init
##
## Copyright 2012-2013, HipSnip Limited
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.


package "redhat-lsb-core"

#Override init script of jetty to run on Centos 6.5 
template "/etc/init.d/jetty" do
     source "jetty_init_el.erb"
     mode 0755
     owner "root"
     group "root"
     notifies  :restart , "service[jetty]" , :delayed
end
