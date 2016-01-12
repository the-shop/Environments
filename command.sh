#!/bin/bash

# Read the first passed in param as environment
export ENV=$1

# Shift input parameters
shift

# Pass in everything else to vagrant
vagrant "$@"