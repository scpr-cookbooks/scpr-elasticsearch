default.scpr_elasticsearch.cluster_name = 'elasticsearch'
default.scpr_elasticsearch.discovery    = false
default.scpr_elasticsearch.consul       = true
default.scpr_elasticsearch.version      = "1.7.3"
default.scpr_elasticsearch.download_url = "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.7.3.tar.gz"
default.scpr_elasticsearch.checksum     = "af517611493374cfb2daa8897ae17e63e2efea4d0377d316baa351c1776a2bca"
default.scpr_elasticsearch.data_path    = "/data/elasticsearch"
default.scpr_elasticsearch.log_path     = "/var/log/elasticsearch"
default.scpr_elasticsearch.es_dir       = "/opt/elasticsearch"

#----------

include_attribute "elasticsearch"

default.elasticsearch.zen.ping.multicast.enabled = node.scpr_elasticsearch.discovery
