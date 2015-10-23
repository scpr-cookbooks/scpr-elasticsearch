default.scpr_elasticsearch.cluster_name = 'elasticsearch'
default.scpr_elasticsearch.discovery    = false
default.scpr_elasticsearch.consul       = true

#----------

include_attribute "elasticsearch"

override.elasticsearch.zen.ping.multicast.enabled = node.scpr_elasticsearch.discovery
override.elasticsearch.version        = "1.7.2"
override.elasticsearch.download_url   = "http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.7.2.tar.gz"
default.elasticsearch.path.data       = "/data/elasticsearch"
default.elasticsearch.path.logs       = "/var/log/elasticsearch"
