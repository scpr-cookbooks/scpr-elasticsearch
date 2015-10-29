#
# Cookbook Name:: scpr-elasticsearch
# Recipe:: default
#
# Copyright (c) 2014 Southern California Public Radio, All Rights Reserved.

node.set.elasticsearch.cluster.name = node.scpr_elasticsearch.cluster_name

include_recipe "scpr-java"

# -- Install Elasticsearch -- #

elasticsearch_user 'elasticsearch' do
  homedir node.scpr_elasticsearch.es_dir
end

elasticsearch_install 'elasticsearch' do
  version           node.scpr_elasticsearch.version
  download_url      node.scpr_elasticsearch.download_url
  download_checksum node.scpr_elasticsearch.checksum
  dir               node.scpr_elasticsearch.es_dir
end

service 'elasticsearch' do
  supports :status => true, :restart => true
  action :nothing
end

elasticsearch_configure 'elasticsearch' do
  dir         node.scpr_elasticsearch.es_dir
  path_conf   "/etc/elasticsearch"
  path_data   node.scpr_elasticsearch.data_path
  path_logs   node.scpr_elasticsearch.log_path
  es_home     node.scpr_elasticsearch.es_dir
  configuration({
    'discovery.zen.ping.multicast.enabled' => node.scpr_elasticsearch.discovery,
    'cluster.name' => node.scpr_elasticsearch.cluster_name,
  })

  notifies :restart, 'service[elasticsearch]'
end

elasticsearch_service 'elasticsearch' do
  service_actions [:enable,:start]
  path_conf       "/etc/elasticsearch"
  bindir          "/opt/elasticsearch/elasticsearch/bin"
  pid_file        "/var/run/elasticsearch.pid"
end

if node.scpr_elasticsearch.consul
  # -- Set up Consul Service -- #

  include_recipe "scpr-consul"

  # write our service check script...
  check_script = "#{node.scpr_consul.checks_dir}/elasticsearch-#{node.scpr_elasticsearch.cluster_name}.rb"
  template check_script do
    action    :create
    source    "es-service-check.rb.erb"
    mode      0755
    variables({
      cluster_name: node.scpr_elasticsearch.cluster_name
    })
  end

  consul_service_def "es-#{node.scpr_elasticsearch.cluster_name}" do
    action    :create
    check({
      interval: '30s',
      script:   check_script,
    })
    port      9200
    tags      ["elasticsearch"]
    notifies  :reload, "service[consul]"
  end
end