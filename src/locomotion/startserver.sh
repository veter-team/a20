#!/bin/sh

# Before running this script, make sure that locomotion.conf is in
# /etc/init 

sudo initctl reload-configuration
sudo start locomotion

