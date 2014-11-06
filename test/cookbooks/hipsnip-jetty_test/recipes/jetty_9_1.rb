node.set['java']['jdk_version'] = 7

node.set['jetty']['version'] = '9.2.3.v20140905'
node.set['jetty']['link'] = 'http://eclipse.org/downloads/download.php?file=/jetty/stable-9/dist/jetty-distribution-9.2.3.v20140905.tar.gz&r=1'
node.set['jetty']['checksum'] = '9a47f2d02efa52583db3195623080ff7ccd96b6aa9150aeaa43e1203de22770a'
include_recipe 'hipsnip-jetty'
