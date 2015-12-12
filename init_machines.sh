#!/bin/bash
docker-machine create -d virtualbox --virtualbox-memory=2048 --virtualbox-cpu-count=4 $1;docker-machine env $1; eval $(docker-machine env $1);
alias d='docker rm -f $(docker ps -a -q);docker rmi -f $(docker images -a -q)'
