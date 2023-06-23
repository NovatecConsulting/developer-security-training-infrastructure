#!/bin/bash
# This script is for checking the installations. Are really all needed packagaes are there? 
#set -x
echo 'check all installations'
command -v docker >/dev/null 2>&1 || { echo >&2 "I require docker but it's not installed.  Aborting."; exit 1; }
command -v docker-compose >/dev/null 2>&1 || { echo >&2 "I require docker-compose but it's not installed.  Aborting."; exit 1; }
echo 'it seems that all is working fine'
echo 'all services available'

