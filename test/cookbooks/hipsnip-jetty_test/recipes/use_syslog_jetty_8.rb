node.set['jetty']['syslog']['enable'] = true
node.set['jetty']['syslog']['priority'] = 'user.notice'
node.set['jetty']['syslog']['tag'] = 'TEST'

include_recipe 'hipsnip-jetty'