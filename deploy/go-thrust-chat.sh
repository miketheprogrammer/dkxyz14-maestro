#!/bin/bash
echo "$1"
echo '$1'
json='{
  "name": "go-thrust-chat-server'$3'",
  "image": "miketheprogrammer/go-thrust-chat-server",
  "command": "",
  "scale": '$1',
  "docker_options": {
    "ExposedPorts": {
      "8000/tcp": {
      }
    },
    "Env": [
      "MSG=hello-from-mike"
    ],
    "HostConfig": {
      "PortBindings": {
        "8000/tcp": [
          {
            "HostPort": "'$2'"
          }
        ]
      }
    }
  },
  "options": {}
}'

echo curl -H \"Content-Type: application/json\" -X POST -d "'$json'" http://$(docker-machine ip c1):8080/application
eval $(echo curl -H \"Content-Type: application/json\" -X POST -d "'$json'" http://$(docker-machine ip c1):8080/application)


if [ -z "$4" ]
then
  echo "There is no old version"
else
  echo "bringing down old version in 10 seconds"
  sleep 0
  json='{
    "name": "go-thrust-chat-server'$4'",
    "image": "miketheprogrammer/go-thrust-chat-server",
    "command": "",
    "scale": 0,
    "docker_options": {
      "ExposedPorts": {
        "8000/tcp": {
        }
      },
      "Env": [
        "MSG=hello-from-mike"
      ],
      "HostConfig": {
        "PortBindings": {
          "8000/tcp": [
            {
              "HostPort": "'$2'"
            }
          ]
        }
      }
    },
    "options": {}
  }'  
  echo curl -H \"Content-Type: application/json\" -X POST -d "'$json'" http://$(docker-machine ip c1):8080/application
  eval $(echo curl -H \"Content-Type: application/json\" -X POST -d "'$json'" http://$(docker-machine ip c1):8080/application)
fi