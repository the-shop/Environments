# The Shop development environments
This repository contains Vagrant + VirtualBox + Puppet setup for multiple 
[development environments](https://github.com/the-shop/Environments#environments). 

## Contents
  1. What is in here
  2. Vagrant flow
  3. Setup
  4. Road map and current state of the project
  5. Notes

### 1. What is in here
This repository is currently set up for local development and it utilizes [Vagrant](https://www.vagrantup.com/) with 
[VirtualBox](https://www.virtualbox.org/) provider to emulate production environment on Windows, OSX and Linux (note 
that it has been tested just on Linux and OSX).

You should [read more on Vagrant](https://docs.vagrantup.com/v2/why-vagrant/index.html) if you're not familiar with it
before you proceed.

Supported box types are: loadbalancer, app (STARCommerce frontend box), database, magento2. 

*This repo is a modified version of of [generated Puphpet template](https://puphpet.com/). Check it out, it's awesome!
Also, all requirements they have, we have as well...*

### 2. Vagrant flow
Vagrant iterates over all files that match following `puphpet/boxes/<ENVIRONMENT>/*.yaml` and presumes they are the 
definitions of VMs.

YAML files are prepended with integers so that they boot and provision in correct order (i.e. magento2 box needs mysql 
box to be available, and that's on `database` box, so database box will have lower integer prepended than magento2 box).

### 3. Setup
Because we support multiple environments, although standard vagrant commands work, they have to be called through our 
`./command.sh` shell script.

Our custom shell script for manipulation accepts following form: `./command.sh <ENVIRONMENT> <VAGRANT_COMMAND>`.

So to start STARCommerce environment for example, you run following command `./command.sh STARCommerce up`. It will spin 
up everything that you need to have local setup available for given environment. More on 
[supported environments](https://github.com/the-shop/Environments#environments) below.

Here are the steps to get everything set from scratch:

  1. Install Vagrant and VirtualBox
  2. Clone this repository to your machine 
  3. From project root, run `./init.sh` shell script (initializes dependencies, also perhaps not needed if you use tool 
  such is [Github Desktop](https://desktop.github.com/))
  4. Run `sh command.sh <ENVIRONMENT> <VAGRANT_COMMAND>` (i.e. `sh command.sh STARCommerce up`)
  5. Update your [hosts file](https://en.wikipedia.org/wiki/Hosts_(file)#Location_in_the_file_system) as described below
  in individual [environment setup](README.md#environments) section
  
### Environments
Currently available environments are:
  - STARCommerce
  - Magento2
  - GenericLAMP

#### "[STARCommerce](https://github.com/the-shop/STARCommerceBoxes)" environment setup

#### "[Magento2](https://github.com/the-shop/Magento2Boxes)" environment setup

#### "[GenericLAMP](https://github.com/the-shop/LAMPBox)" environment setup

To see what's exactly happening, check out `*.yaml` files in `/puphpet/boxes` directory after you run the `./init.sh`
script.

### 4. Road map and current state of the project
Original road map planning is available at our [corporate blog](http://the-shop.io/star-commerce-roadmap/) and we're 
**currently in phase of working on 
[STARCommerceFrontend application](https://github.com/the-shop/STARCommerceFrontend)**.

This repository contains entire infrastructure definition and all repositories it depends on described through Vagrant 
and Puppet files.

### 5. Notes
  1. Tested on Ubuntu 15.10 (Vagrant v1.7.4 and VirtualBox v5.0.10) and OSX (Vagrant v1.7.4 and VirtualBox v5.0.10)
  2. READMEs are perhaps not 100% accurate, please file any issues via 
  [GitHub issues](https://github.com/the-shop/STARCommerceFrontend/issues)
