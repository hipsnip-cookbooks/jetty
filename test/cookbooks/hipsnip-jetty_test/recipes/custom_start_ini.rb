node.set['java']['jdk_version'] = 6

node.set['jetty']['port'] = 8080
node.set['jetty']['version'] = '8.1.10.v20130312'
node.set['jetty']['link'] = 'http://eclipse.org/downloads/download.php?file=/jetty/8.1.10.v20130312/dist/jetty-distribution-8.1.10.v20130312.tar.gz&r=1'
node.set['jetty']['checksum'] = 'e966f87823adc323ce67e99485fea126b84fff5affdc28aa7526e40eb2ec1a5b'

# Interesting attributes here, currently tested now
node.set['jetty']['start_ini']['custom'] = true
node.set['jetty']['start_ini']['content'] = [
	'OPTIONS=Server,jsp',
	'etc/jetty.xml',
	'etc/jetty-deploy.xml',
	'etc/jetty-webapps.xml',
	'etc/jetty-contexts.xml'
]

include_recipe 'hipsnip-jetty'