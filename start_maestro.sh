#!/bin/bash
docker build -t miketheprogrammer/maestro ./maestro/; docker run -t -d --volume=/var/run/docker.sock:/var/run/docker.sock --env ENGINE_LOCAL=true --net=host miketheprogrammer/maestro
docker build -t miketheprogrammer/registration-service ./registration-service/; docker run -t -d --volume=/var/run/docker.sock:/var/run/docker.sock --net=host miketheprogrammer/registration-service