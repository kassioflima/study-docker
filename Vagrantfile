# frozen_string_literal: true

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.boot_timeout = 600

  machines = {
    "master" => "192.168.56.10",
    "node01" => "192.168.56.11",
    "node02" => "192.168.56.12",
    "node03" => "192.168.56.13"
  }

  machines.each do |name, ip|
    config.vm.define name do |machine|
      machine.vm.hostname = name
      machine.vm.network "private_network", ip: ip

      machine.vm.provider "virtualbox" do |vb|
        vb.name = "docker-swarm-#{name}"
        vb.cpus = 2
        vb.memory = 2048
      end

      machine.vm.provision "shell", path: "scripts/install-docker.sh", privileged: true

      if name == "master"
        machine.vm.provision "shell", path: "scripts/init-manager.sh", privileged: true
      else
        machine.vm.provision "shell", path: "scripts/join-worker.sh", args: ["192.168.56.10"], privileged: true
      end
    end
  end
end
