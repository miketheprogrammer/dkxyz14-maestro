
SETUP
==========================

Install docker-machine
--------------------------
https://docs.docker.com/machine/install-machine/

Start our dev machine
--------------------------
```bash
./init_machines.sh
```

Test env and connect if fail
--------------------------
```bash
docker ps
# if FAIL
eval $(docker-machine env c1)
```

Run start scripts for consul and maestro
--------------------------
```bash
./start_consul.sh
./start_maestro.sh

docker ps
```

Build images for our hello apps and the go-thrust-chat-server
--------------------------
```bash
./build_images.sh
```

Test access to consul
---------------------------
```bash
curl http://$(docker-machine ip c1):8500/

# <a href="/ui/">Moved Permanently</a>.
```


Test access to maestro
---------------------------
```bash
curl http://$(docker-machine ip c1):8080/
# Cannot GET /
```

Run build scripts for images
```

Registering applications
--------------------------
Download and open up your favorite http client like Postman for Chrome

In ./fixtures you will find some json to get you started

Accessing Applications
--------------------------

It is relatively simple to create a Node/Go/Haproxy whatever you want, proxy for Consul services. I did not do it here, but have done
it for other architectures.

For now, simple access the consul ui

Navigate to http://mydockermachineip:8500/ui

From there access the nodes tab. Find your service and their ports and access

http://mydockermachineip:myserviceport


Zero Downtime Deployments
--------------------------

Zero DT Deployments, in this case, are executing by creating another application with a different image or image:tag combo and
deploying that application.

Basically the flow is like this

1. Deploy your first application
2. Change the code
3. Build the dockerfile with a different image:tag
4. Copy the first applications json, and modify the name and image
5. Deploy the new application
6. Now just change the original application's scale using another POST /applications to 0
7. Maestro will now scale down the old application.


Alternatives Zero DT methods
--------------------------
Code a deployments object. It will manage cycling deployments, and reverting.
It can exist at /deployments



