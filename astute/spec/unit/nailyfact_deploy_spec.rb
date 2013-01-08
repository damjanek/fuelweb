#!/usr/bin/env rspec
require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe "NailyFact DeploymentEngine" do
  context "When deploy is called, " do
    before(:each) do
      @ctx = mock
      @ctx.stubs(:task_id)
      reporter = mock
      @ctx.stubs(:reporter).returns(reporter)
      reporter.stubs(:report)
      @deploy_engine = Astute::DeploymentEngine::NailyFact.new(@ctx)
      @data = {"args" =>
                {"attributes" =>
                  {"storage_network_range" => "172.16.0.0/24", "auto_assign_floating_ip" => false,
                   "mysql" => {"root_password" => "Z2EqsZo5"},
                   "keystone" => {"admin_token" => "5qKy0i63", "db_password" => "HHQ86Rym", "admin_tenant" => "admin"},
                   "nova" => {"user_password" => "h8RY8SE7", "db_password" => "Xl9I51Cb"},
                   "glance" => {"user_password" => "nDlUxuJq", "db_password" => "V050pQAn"},
                   "rabbit" => {"user" => "nova", "password" => "FLF3txKC"},
                   "management_network_range" => "192.168.0.0/24",
                   "public_network_range" => "240.0.1.0/24",
                   "fixed_network_range" => "10.0.0.0/24",
                   "floating_network_range" => "240.0.0.0/24"},
               "task_uuid" => "19d99029-350a-4c9c-819c-1f294cf9e741",
               "nodes" => [{"mac" => "52:54:00:0E:B8:F5", "status" => "provisioning",
                            "uid" => "devnailgun.mirantis.com", "error_type" => nil,
                            "fqdn" => "devnailgun.mirantis.com",
                            "network_data" => [{"gateway" => "192.168.0.1",
                                                "name" => "management", "dev" => "eth0",
                                                "brd" => "192.168.0.255", "netmask" => "255.255.255.0",
                                                "vlan" => 102, "ip" => "192.168.0.2/24"},
                                               {"gateway" => "240.0.1.1",
                                                "name" => "public", "dev" => "eth0",
                                                "brd" => "240.0.1.255", "netmask" => "255.255.255.0",
                                                "vlan" => 101, "ip" => "240.0.1.2/24"},
                                               {"name" => "floating", "dev" => "eth0", "vlan" => 120},
                                               {"name" => "fixed", "dev" => "eth0", "vlan" => 103},
                                               {"name" => "storage", "dev" => "eth0", "vlan" => 104}],
                            "id" => 1,
                            "ip" => "10.20.0.200",
                            "role" => "controller"},
                           {"mac" => "52:54:00:50:91:DD", "status" => "provisioning",
                            "uid" => 2, "error_type" => nil,
                            "fqdn" => "slave-2.mirantis.com",
                            "network_data" => [{"gateway" => "192.168.0.1",
                                                "name" => "management", "dev" => "eth0",
                                                "brd" => "192.168.0.255", "netmask" => "255.255.255.0",
                                                "vlan" => 102, "ip" => "192.168.0.3/24"},
                                               {"gateway" => "240.0.1.1",
                                                "name" => "public", "dev" => "eth0",
                                                "brd" => "240.0.1.255", "netmask" => "255.255.255.0",
                                                "vlan" => 101, "ip" => "240.0.1.3/24"},
                                               {"name" => "floating", "dev" => "eth0", "vlan" => 120},
                                               {"name" => "fixed", "dev" => "eth0", "vlan" => 103},
                                               {"name" => "storage", "dev" => "eth0", "vlan" => 104}],
                            "id" => 2,
                            "ip" => "10.20.0.221",
                            "role" => "compute"},
                           {"mac" => "52:54:00:C3:2C:28", "status" => "provisioning",
                            "uid" => 3, "error_type" => nil,
                            "fqdn" => "slave-3.mirantis.com",
                            "network_data" => [{"gateway" => "192.168.0.1",
                                                "name" => "management", "dev" => "eth0",
                                                "brd" => "192.168.0.255", "netmask" => "255.255.255.0",
                                                "vlan" => 102, "ip" => "192.168.0.4/24"},
                                               {"gateway" => "240.0.1.1",
                                                "name" => "public", "dev" => "eth0",
                                                "brd" => "240.0.1.255", "netmask" => "255.255.255.0",
                                                "vlan" => 101, "ip" => "240.0.1.4/24"},
                                               {"name" => "floating", "dev" => "eth0", "vlan" => 120},
                                               {"name" => "fixed", "dev" => "eth0", "vlan" => 103},
                                               {"name" => "storage", "dev" => "eth0", "vlan" => 104}],
                            "id" => 3,
                            "ip" => "10.20.0.68",
                            "role" => "compute"}]},
              "method" => "deploy",
              "respond_to" => "deploy_resp"}
    end

    it "it should call valid method depends on attrs" do
      nodes = [{'uid' => 1}]
      attrs = {'deployment_mode' => 'ha_compute'}
      attrs_modified = attrs.merge({'some' => 'somea'})
      
      @deploy_engine.expects(:attrs_ha_compute).with(nodes, attrs).returns(attrs_modified)
      @deploy_engine.expects(:deploy_ha_compute).with(nodes, attrs_modified)
      # All implementations of deploy_piece go to subclasses
      @deploy_engine.respond_to?(:deploy_piece).should be_true
      @deploy_engine.deploy(nodes, attrs)
    end

    it "it should raise an exception if deployment mode is unsupported" do
      nodes = [{'uid' => 1}]
      attrs = {'deployment_mode' => 'unknown'}
      expect {@deploy_engine.deploy(nodes, attrs)}.to raise_exception(/Method attrs_unknown is not implemented/)
    end

    it "multinode_compute deploy should not raise any exception" do
      @data['args']['attributes']['deployment_mode'] = "multinode_compute"
      Astute::Metadata.expects(:publish_facts).times(@data['args']['nodes'].size)
      # we got two calls, one for controller, and another for all computes
      Astute::PuppetdDeployer.expects(:deploy).twice
      @deploy_engine.deploy(@data['args']['nodes'], @data['args']['attributes'])
    end

    it "ha_compute deploy should not raise any exception" do
      @data['args']['attributes']['deployment_mode'] = "ha_compute"
      # VIPs are required for HA mode and should be passed from Nailgun (only in HA)
      @data['args']['attributes']['management_vip'] = "192.168.0.5"
      @data['args']['attributes']['public_vip'] = "240.0.1.5"

      Astute::Metadata.expects(:publish_facts).times(@data['args']['nodes'].size)
      # FIXME: this test should also handle few controllers. If there are more than one controller,
      #  deployment is called for controllers one by one, and then for computes.
      # we got two calls, one for controller, and another for all computes
      Astute::PuppetdDeployer.expects(:deploy).twice
      @deploy_engine.deploy(@data['args']['nodes'], @data['args']['attributes'])
    end

    it "singlenode_compute deploy should not raise any exception" do
      @data['args']['attributes']['deployment_mode'] = "singlenode_compute"
      @data['args']['nodes'] = [@data['args']['nodes'][0]]  # We have only one node in singlenode
      Astute::Metadata.expects(:publish_facts).times(@data['args']['nodes'].size)
      Astute::PuppetdDeployer.expects(:deploy).once  # one call for one node
      @deploy_engine.deploy(@data['args']['nodes'], @data['args']['attributes'])
    end
  end
end