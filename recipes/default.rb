#
# Cookbook Name:: scpr-elasticsearch
# Recipe:: default
#
# Copyright (c) 2014 Southern California Public Radio, All Rights Reserved.

node.set.elasticsearch.cluster.name = node.scpr_elasticsearch.cluster_name

include_recipe "java"
include_recipe "elasticsearch"

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
  tags      ["elasticsearch"]
  notifies  :reload, "service[consul]"
end