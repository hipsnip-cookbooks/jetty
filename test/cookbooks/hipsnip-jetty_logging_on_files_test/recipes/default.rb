node.set['java']['jdk_version'] = 7

node.set['jetty']['port'] = 8080
node.set['jetty']['version'] = '9.0.2.v20130417'
node.set['jetty']['link'] = 'http://eclipse.org/downloads/download.php?file=/jetty/stable-9/dist/jetty-distribution-9.0.2.v20130417.tar.gz&r=1'
node.set['jetty']['checksum'] = '6ab0c0ba4ff98bfc7399a82a96a047fcd2161ae46622e36a3552ecf10b9cddb9'
node.set['jetty']['add_confs'] = ['etc/jetty-logging.xml']
node.set['jetty']['logs'] = '/var/log/jetty'

include_recipe 'hipsnip-jetty'