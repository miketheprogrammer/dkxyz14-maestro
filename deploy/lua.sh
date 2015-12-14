#!/bin/bash
#!/bin/bash
echo "$1"
echo '$1'
json='{
  "name": "hello-lua'$3'",
  "image": "miketheprogrammer/hello-lua",
  "command": "",
  "scale": '$1',
  "docker_options": {
    "ExposedPorts": {
      "8080/tcp": {
      }
    },
    "Env": [
      "MSG=hello-from-mike"
    ],
    "HostConfig": {
      "PortBindings": {
        "8080/tcp": [
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
    "name": "hello-lua'$4'",
    "image": "miketheprogrammer/hello-lua",
    "command": "",
    "scale": 0,
    "docker_options": {
      "ExposedPorts": {
        "8080/tcp": {
        }
      },
      "Env": [
        "MSG=hello-from-mike"
      ],
      "HostConfig": {
        "PortBindings": {
          "8080/tcp": [
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