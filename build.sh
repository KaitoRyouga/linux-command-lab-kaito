#!/bin/bash

touch list-folder.txt
ls -d */ > list-folder.txt
COUNT=$(wc -l list-folder.txt | cut -d" " -f 1)
num=1210
VERSION=latest

for (( c=1; c<=$COUNT; c++ ))
do  
  echo $c
  FOLDER=$(head -n $c list-folder.txt | tail -n 1 | cut -d"/" -f 1)
  PORT=$((num + c))
  echo "
    ${FOLDER}:
      restart: always
      build: 
        context: ./${FOLDER}
        dockerfile: Dockerfile
      ports:
        - \"${PORT}:22\"
  " >> docker-compose.yml

  echo "
  kaito_${FOLDER}:
    restart: always
    image: docker.pkg.github.com/kaitoryouga/linux-command-lab-kaito/kaito_${FOLDER}:latest
    ports:
      - \"${PORT}:22\"
    environment:
      HTTP_PORT: ${PORT}
    networks:
      service_network:
  " >> docker-compose.cloud.yml

done

docker-compose -p kaito build

for (( c=1; c<=$COUNT; c++ ))
do  
  FOLDER=$(head -n $c list-folder.txt | tail -n 1 | cut -d"/" -f 1)
  docker tag kaito_${FOLDER} docker.pkg.github.com/kaitoryouga/linux-command-lab-kaito/kaito_${FOLDER}:$VERSION
  docker push docker.pkg.github.com/kaitoryouga/linux-command-lab-kaito/kaito_${FOLDER}:$VERSION
done

# cat docker-compose.yml

cat networks-volumes.txt >> docker-compose.cloud.yml

echo "============================================================================"

# cat docker-compose.cloud.yml

