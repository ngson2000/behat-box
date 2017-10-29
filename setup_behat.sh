#!/bin/sh
#=========================================================

# Check if the behat env is ready
if [ -f $HOME/.behatisready ]; then
    exit
fi

CURDIR=`pwd`
cd $HOME
#=========================================================
echo "Copying necessary files from /vagrant/upload/..."
#=========================================================
if [ ! -d /vagrant/upload ]; then
    echo -e "The upload folder is not found.\n\
Please run 'vagrant up' in the cloned folder"
    exit
fi
if [ -f /vagrant/upload/composer.phar -a ! -f $HOME/composer.phar ]; then
    cp -f /vagrant/upload/composer.phar $HOME
fi
if [ -f /vagrant/upload/composer.json -a ! -f $HOME/composer.json ]; then
    cp -f /vagrant/upload/composer.json $HOME
fi
if [ -f /vagrant/upload/chromedriver_linux64.zip -a ! -f $HOME/bin/chromedriver ]; then
    unzip -q /vagrant/upload/chromedriver_linux64.zip -d $HOME/bin
fi
echo "ok"

#=========================================================
echo "Self update PHP composer and update behat 3.4.1 components..."
#=========================================================
php composer.phar self-update
php composer.phar show behat/behat 3.4.1  > /dev/null 2>&1
if [ $? -ne 0 ]; then
php composer.phar update
fi
echo "ok"

#=========================================================
echo "Install google chrome..."
#=========================================================
dpkg -l google-chrome-stable > /dev/null 2>&1
if [ $? -ne 0 -a -f /vagrant/upload/google-chrome-stable_current_amd64.deb ]; then
	sudo dpkg -i /vagrant/upload/google-chrome-stable_current_amd64.deb
	sudo apt-get install -y -f
fi
echo "ok"

#=========================================================
echo "Unzip Firefox 47.0.2..."
#=========================================================
if [ -f /vagrant/upload/firefox-47.0.2.tar.bz2 -a ! -f $HOME/bin/firefox/firefox ]; then
	tar xfj /vagrant/upload/firefox-47.0.2.tar.bz2 --directory $HOME/bin
fi
# Add firefox binary path into $PATH
grep -q "firefox" .profile
if [ $? -ne 0 ]; then
    echo "PATH=\$HOME/bin/firefox:\$PATH" >> .profile
    export PATH=$HOME/bin/firefox:$PATH
fi
echo "ok"

#=========================================================
echo "Copy selenium server standlone 2.53.1 ..."
#=========================================================
if [ -f /vagrant/upload/selenium-server-standalone-2.53.1.jar -a ! -f $HOME/bin/selenium-server-standalone.jar ]; then
	cp /vagrant/upload/selenium-server-standalone-2.53.1.jar $HOME/bin/selenium-server-standalone.jar
fi
echo "ok"

echo "Behat testing environment is ready" > $HOME/.behatisready
cd $CURDIR