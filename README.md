# STAR Commerce project
STAR Commerce is front end component used for implementation of horizontally scalable eCommerce platforms. It utilizes
existing administration interfaces and APIs of current eCommerce installations for entire back end functionality while
giving complete control over front end.

## Contents
  1. What is in here
  2. Setup
  3. Road map and current state of the project
  4. Notes

### 1. What is in here
This repository is currently set up for local development and it utilizes [Vagrant](https://www.vagrantup.com/) with 
[VirtualBox](https://www.virtualbox.org/) provider to emulate production environment on Windows, OS X and Linux.

You should [read more on Vagrant](https://docs.vagrantup.com/v2/why-vagrant/index.html) if you're not familiar with it
before you proceed.

Supported box types are: loadbalancer, application, database, magento2. Initial `vagrant up` will spin up 
everything that you need to have local setup available at `star.commerce.dev`, `magento2.api.provider` and/or 
`magento2.dev` on you machine after following setup below and depending on what environment are you setting up.

Also, there might be other boxes in the future, so check out *Setup* section below in the future if you have any issues.

*This repo is a modified version of of [generated Puphpet template](https://puphpet.com/). Check it out, it's awesome!
Also, all requirements they have, we have as well...*

### Setup
Setup is fairly simple as it consists of just 6 steps:

  1. Install Vagrant and VirtualBox
  2. Clone this repository to your machine 
  3. From project root, run `init.sh` shell script (initializes dependencies)
  4. Copy file `puphpet/boxes/<ENVIRONMENT>/hiera/magento2_data.yaml.dist` to `puphpet/boxes/<ENVIRONMENT>/hiera/magento2_data.yaml` and update 
  contents of copied file. Magento connect data is mandatory in order to get `magento2` box up and running. Instructions 
  are available here: 
  ([magento connect credentials](https://www.magentocommerce.com/magento-connect/customerdata/secureKeys/list/))
  5. Run `sh command.sh <ENVIRONMENT> <VAGRANT_COMMAND>` (i.e. `sh command.sh STARCommerce up`)
  6. Update your [hosts file](https://en.wikipedia.org/wiki/Hosts_(file)#Location_in_the_file_system) as described below
  in [Environments](README.md#environments) section
  
### Environments
Currently available environments are:
  - STARCommerce
  - Magento2
  
Both of them require 
[Magento connect key pair]((https://www.magentocommerce.com/magento-connect/customerdata/secureKeys/list/)) in order to 
be fully and correctly provisioned. 

#### "[STARCommerce](https://github.com/the-shop/STARCommerceBoxes)" environment
  - STAR Commerce application will be accessible through load balancer at
[http://star.commerce.dev](http://star.commerce.dev) and Magento 2 installation at 
[http://magento2.api.provider](http://magento2.api.provider).
  - Hosts setup: append `192.168.56.100 star.commerce.dev` and `192.168.56.102 magento2.api.provider` lines to your 
[hosts file](https://en.wikipedia.org/wiki/Hosts_(file)#Location_in_the_file_system)

#### "[Magento2](https://github.com/the-shop/Magento2Boxes)" environment
  - Magento 2 will be accessible through load balancer at
[http://magento2.dev](http://magento2.dev).
  - Hosts setup: append `192.168.56.120 magento2.dev`line to your 
[hosts file](https://en.wikipedia.org/wiki/Hosts_(file)#Location_in_the_file_system)

To see what's exactly happening, check out `*.yaml` files in `/puphpet/boxes` directory

### Road map and current state of the project
Original road map planning is available at our [corporate blog](http://the-shop.io/star-commerce-roadmap/) and we're 
**currently in phase of working on 
[STARCommerceFrontend application](https://github.com/the-shop/STARCommerceFrontend)**.

This repository contains entire infrastructure definition and all repositories it depends on described through Vagrant 
and Puppet files.

### Notes
  1. Tested on Ubuntu 15.10 (Vagrant v1.7.4 and VirtualBox v5.0.10)
  2. READMEs are perhaps not 100% accurate, please file any issues via 
  [GitHub issues](https://github.com/the-shop/STARCommerceFrontend/issues)
  3. Load Balancer statistics can be accessed at `http://star.commerce.dev/haproxy?stats` or 
  `http://magento2.dev/haproxy?stats` with username `haproxy` and password `password` - that can be changed in
   `/puphpet/boxes/STARCommerce/hiera/loadbalancer.yaml` and/or `/puphpet/boxes/Magento2/hiera/loadbalancer.yaml` files.