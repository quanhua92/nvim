sudo apt install python3-pip

sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

pip3 install apt-select

cd /tmp/
sudo apt-select --country vn

sudo mv /tmp/sources.list /etc/apt/sources.list

sudo apt update
