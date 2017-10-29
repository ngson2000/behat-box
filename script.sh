#!/bin/sh
#=========================================================

#=========================================================
echo "Install the packages..."
#=========================================================
sudo apt-get update
sudo apt-get -y install fluxbox xorg unzip vim default-jre rungetty

#=========================================================
echo "Install php 5 and extensions..."
#=========================================================
sudo apt-get -y install php5-cli php5-curl

#=========================================================
echo "Create swap partition..."
#=========================================================
swapsize=1024
# does the swap file already exist?
grep -q "swapfile" /etc/fstab
# if not then create it
if [ $? -ne 0 ]; then
	sudo fallocate -l ${swapsize}M /swapfile
	sudo chmod 600 /swapfile
	sudo mkswap /swapfile
	sudo swapon /swapfile
	sudo sh -c "echo '/swapfile none swap defaults 0 0' >> /etc/fstab"
fi
echo "ok"

#=========================================================
echo "Set autologin for the vagrant user..."
#=========================================================
sudo sed -i '$ d' /etc/init/tty1.conf
sudo echo "exec /sbin/rungetty --autologin vagrant tty1" >> /etc/init/tty1.conf
echo "ok"

#=========================================================
echo -n "Start X on login..."
#=========================================================
grep -q "startx" .profile
if [ $? -ne 0 ]; then
    PROFILE_STRING=$(cat <<EOF
if [ ! -e "/tmp/.X0-lock" ] ; then
    startx
fi
EOF
)
    echo "${PROFILE_STRING}" >> .profile
fi
grep -q "cd /vagrant" .profile
if [ $? -ne 0 ]; then
    echo "cd /vagrant" >> .profile
fi
echo "ok"

#=========================================================
echo -n "Install tmux scripts..."
#=========================================================
TMUX_SCRIPT=$(cat <<EOF
#!/bin/sh
tmux start-server

tmux new-session -d -s selenium
tmux send-keys -t selenium:0 './bin/chromedriver' C-m

tmux new-session -d -s chrome-driver
tmux send-keys -t chrome-driver:0 'java -jar ./bin/selenium-server-standalone.jar' C-m
EOF
)
echo "${TMUX_SCRIPT}"
echo "${TMUX_SCRIPT}" > tmux.sh
chmod +x tmux.sh
chown vagrant:vagrant tmux.sh
echo "ok"

#=========================================================
echo -n "Install startup scripts..."
#=========================================================
STARTUP_SCRIPT=$(cat <<EOF
#!/bin/sh
~/tmux.sh &
xterm &
EOF
)
echo "${STARTUP_SCRIPT}" > /etc/X11/Xsession.d/9999-common_start
chmod +x /etc/X11/Xsession.d/9999-common_start
echo "ok"

#=========================================================
echo -n "Add host alias..."
#=========================================================
echo "192.168.33.1 host" >> /etc/hosts
echo "ok"

#=========================================================
echo "Please run 'vagrant reload' to continue"
#=========================================================
