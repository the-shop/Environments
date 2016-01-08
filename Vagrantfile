# -*- mode: ruby -*-

dir = File.dirname(File.expand_path(__FILE__))

require 'yaml'
require "#{dir}/puphpet/ruby/puppet.rb"

Vagrant.require_version '>= 1.6.0'

environment = ENV['ENV'] || 'not-set'

if environment == 'not-set'
  puts "Current setup depends on environment variable ENV, for simplicity please use ./command.sh shell script"
  puts "Format it accepts is 'command.sh <ENVIRONMENT_NAME> <VAGRANT_COMMAND>'', i.e. 'sh command.sh STARCommerce up'"
  exit 1
end

if !Dir.exists?("#{dir}/puphpet/boxes/#{environment}/")
  puts "Seems like the specified environment (#{environment}) configuration is missing."
  puts "Search directory for given environment: '#{dir}/puphpet/boxes/#{environment}/*.yaml'"
  puts "P.S. Double check what's supported out of the box in main README.md file"
  exit 1
end

# Boxes are defined in *.yaml format in /puphpet/boxes directory
configBoxesList = Dir.glob("#{dir}/puphpet/boxes/#{environment}/*.yaml").sort

if configBoxesList.empty?
  puts "Config files scanned as '#{dir}/puphpet/boxes/#{environment}/*.yaml' doesn't contain YAML files"
  exit 1
end

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
