#!/bin/bash

NAME=kafka-zookeeper-two-one

docker stack rm $NAME

docker swarm leave --force
