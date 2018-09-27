#!/bin/bash

for id in `docker ps -a | grep -v rancher | awk -F ' ' '{print $1}' | tail -n +2`; 
do 
  docker rm -f $id; 
done;
docker images | grep movie | awk -F ' ' '{print $3}' | xargs -n1 docker rmi
