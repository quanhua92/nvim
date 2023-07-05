sudo apt install python3-pip

sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

pip3 install apt-select

cd /tmp/
apt-select --country vn -t 5 -c

sudo mv /tmp/sources.list /etc/apt/sources.list

sudo apt update
