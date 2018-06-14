# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://10.0.2.2:1087/"
    config.proxy.https    = "http://10.0.2.2:1087/"
  end

  config.vm.box = "centos/7"
  config.vm.provision "shell", path: "provision/docker_install.sh"

  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "192.168.33.20"
    master.vm.provision "shell", path: "provision/kubernetes_install.sh", env: {"NODE_IP" => "192.168.33.20"}
    master.vm.provision "shell", path: "provision/master_init.sh", env: {"NODE_IP" => "192.168.33.20"}, privileged: false
    for p in [:virtualbox, :libvirt] do
      master.vm.provider p do |provider|
        provider.memory = 2048
      end
    end
  end

  (1..2).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.hostname = "node#{i}"
      node.vm.provision "shell", path: "provision/kubernetes_install.sh", env: {"NODE_IP" => "192.168.33.2#{i}"}
      node.vm.network "private_network", ip: "192.168.33.2#{i}"
      for p in [:virtualbox, :libvirt] do
        node.vm.provider p do |provider|
          provider.memory = 2048
        end
      end
    end
  end

end
