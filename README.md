
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

Registering applications
--------------------------
Download and open up your favorite http client like Postman for Chrome

In ./fixture you will find some json to get you started