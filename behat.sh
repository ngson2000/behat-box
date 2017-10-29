#!/bin/sh
#=========================================================

# Run this script in VM box
if [ ! -d /vagrant ]; then
    echo "Please run this script in Behat Box"
    exit
fi

if [ ! -f $HOME/.behatisready ]; then
    echo "Setting up the behat environment. Pleae wait..."
    ./setup_behat.sh
fi

$HOME/vendor/bin/behat $@