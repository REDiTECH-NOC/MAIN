# Install Portainer 
> (https://docs.portainer.io/start/install-ce/server/docker/linux)
> 
Make your Portainer Volume (This is the location I install all my docker volumes):
```
sudo mkdir /srv/config/portainer_data
```
Then, download and install the Portainer Server container:
```
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /srv/config/portainer_data:/data portainer/portainer-ce:latest
```
Portainer Server has now been installed. You can check to see whether the Portainer Server container has started by running:
```
sudo docker ps
```
<pre>
root@server:~# docker ps
CONTAINER ID   IMAGE                          COMMAND                  CREATED       STATUS      PORTS                                                                                  NAMES             
de5b28eb2fa9   portainer/portainer-ce:latest  "/portainer"             2 weeks ago   Up 9 days   0.0.0.0:8000->8000/tcp, :::8000->8000/tcp, 0.0.0.0:9443->9443/tcp, :::9443->9443/tcp   portainer
</pre>

Login:          
> https://localhost:9443

# How to update Portainer
stop container:
```
sudo docker stop portainer
```
remove old container:
```
sudo docker rm portainer
```
Pull the new image:
```
sudo docker pull portainer/portainer-ce:latest
```
Run the new container:
```
sudo docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /srv/config/portainer_data:/data portainer/portainer-ce:latest
```



# How to update Portainer
stop container:
```docker stop portainer```
remove old container:
```docker rm portainer```
Pull the new image:
```docker pull portainer/portainer-ce:latest```
Run the new container:
```docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /srv/config/portainer_data:/data portainer/portainer-ce:latest```