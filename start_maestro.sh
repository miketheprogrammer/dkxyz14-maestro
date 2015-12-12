#!/bin/bash
#docker build --no-cache -t miketheprogrammer/maestro ./maestro/; docker run -t --net=host miketheprogrammer/maestro
docker build --no-cache -t miketheprogrammer/maestro ./maestro/; docker run -it --volume=/var/run/docker.sock:/var/run/docker.sock --env ENGINE_LOCAL=true --net=host miketheprogrammer/maestro