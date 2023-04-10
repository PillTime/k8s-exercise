#!/bin/sh

curl \
    -X POST \
    -H 'Content-Type: application/json' \
    -d '{
        "email": "steven@gmail.com",
        "password": "password"
    }' \
    localhost:8080/login \
    | tr -d '"\n' > token.txt
