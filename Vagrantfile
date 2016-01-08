# -*- mode: ruby -*-

dir = File.dirname(File.expand_path(__FILE__))

require 'yaml'
require "#{dir}/puphpet/ruby/puppet.rb"

Vagrant.require_version '>= 1.6.0'

# Boxes are defined in *.yaml format in /puphpet/boxes directory
configBoxesList = Dir.glob("#{dir}/puphpet/boxes/*.yaml").sort

vagrant_home = (ENV['VAGRANT_HOME'].to_s.split.join.length > 0) ? ENV['VAGRANT_HOME'] : "#{ENV['HOME']}/.vagrant.d"
vagrant_dot  = (ENV['VAGRANT_DOTFILE_PATH'].to_s.split.join.length > 0) ? ENV['VAGRANT_DOTFILE_PATH'] : "#{dir}/.vagrant"

Vagrant.configure('2') do |vagrantConfig|
  # Iterate over config file locations
  configBoxesList.each do |configLocation|

    # Read Vagrant related configuration
    configValues = YAML.load_file(configLocation)
    data = configValues['vagrantfile']

    # Define box based on current box config
    vagrantConfig.vm.define "#{data['vm']['hostname']}" do |config|

      config.vm.box     = "#{data['vm']['box']}"
      config.vm.box_url = "#{data['vm']['box_url']}"

      # Run external Vagrantfile
      eval File.read("#{dir}/puphpet/vagrant/Vagrantfile-#{data['target']}")

    end

  end

end
