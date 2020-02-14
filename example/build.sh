#!/bin/bash

. .env

docker-compose up -d database

docker build  --no-cache -t magento --network example_default .

docker-compose up -d
