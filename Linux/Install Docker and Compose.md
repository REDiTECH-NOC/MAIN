# Install Docker Ubuntu 20.04, 22.04, 22.10, 23.04
```
sudo apt update
```

sudo apt install apt-transport-https ca-certificates curl software-properties-common

url -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

apt-cache policy docker-ce

sudo apt install docker-ce

sudo systemctl status docker

# Install Docker Compose
sudo curl -L https://github.com/docker/compose/releases/download/2.10.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
