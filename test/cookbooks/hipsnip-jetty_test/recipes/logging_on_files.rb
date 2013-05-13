
node.set['jetty']['add_confs'] = ['etc/jetty-logging.xml']
node.set['jetty']['logs'] = '/var/log/jetty'

include_recipe 'hipsnip-jetty'