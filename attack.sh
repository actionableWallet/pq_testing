#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' 

make 
for fragments in {250..1500..250}; do
    echo "Testing with ${fragments} fragments..."
    
    if ! ./arrf_dynamic $fragments "attack"; then
        echo -e "${RED}Successful memory exhaustion attack!${NC}"
        echo "$(date): arrf_dynamic failed with input ${fragments} fragments 'attack'"
        exit 1
    else
        echo -e "${GREEN}Memory exhaustion attack bypassed for arrf_dynamic!${NC}"
    fi

    if ! ./arrf_static $fragments "attack"; then
        echo -e "${RED}Successful memory exhaustion attack on arrf_static!${NC}"
        echo "$(date): arrf_static failed with input ${fragments} fragments 'attack'"
        exit 1
    else
        echo -e "${GREEN}Memory exhaustion attack bypassed for arrf_static!${NC}"
    fi
done