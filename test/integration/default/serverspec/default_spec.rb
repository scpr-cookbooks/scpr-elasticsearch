require 'spec_helper'

describe 'scpr-elasticsearch::default' do
  # Elasticsearch is installed
  describe file("/opt/elasticsearch/elasticsearch/bin/elasticsearch") do
    it { should exist }
    it { should be_executable }
  end

  # Elasticsearch is running
  describe service("elasticsearch") do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(9200) do
    it { should be_listening }
  end

  # Log is being written in the right place

  describe file("/var/log/elasticsearch/elasticsearch.log") do
    it { should exist }
  end

  # Data should be in the right place

  describe file("/data/elasticsearch/elasticsearch/nodes/0/node.lock") do
    it { should exist }
  end

  # Consul is running

  describe service("consul") do
    it { should be_enabled }
    it { should be_running }
  end

  # Our Consul service is registered

  describe command("curl http://localhost:8500/v1/catalog/service/es-elasticsearch") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should contain '"ServiceName":"es-elasticsearch"'}
  end
end
