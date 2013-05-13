node.set['java']['jdk_version'] = 7

node.set['jetty']['port'] = 8081
node.set['jetty']['version'] = '9.0.3.v20130506'
node.set['jetty']['link'] = 'http://eclipse.org/downloads/download.php?file=/jetty/9.0.3.v20130506/dist/jetty-distribution-9.0.3.v20130506.tar.gz&r=1'
node.set['jetty']['checksum'] = 'eff8c9c63883cae04cec82aca01640411a6f8804971932cd477be2f98f90a6c4'
node.set['jetty']['add_confs'] = [
	'jetty.port=8081'
]
include_recipe 'hipsnip-jetty'