#!/bin/bash

NAME=kafka-zookeeper-two-one

docker swarm init

docker stack deploy -c docker-compose.yml $NAME

docker stack ls

docker service ls
