#!/bin/sh

curl \
    -X POST \
    -H 'Content-Type: application/json' \
    -d '{
        "email": "e@mail.com",
        "password": "password1"
    }' \
    localhost:8080/login \
    | tr -d '"\n' > token.txt
