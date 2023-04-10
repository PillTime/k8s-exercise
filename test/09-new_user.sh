#!/bin/sh

curl \
    -X POST \
    -H 'Content-Type: application/json' \
    -d '{
        "nickname": "New User",
        "email": "e@mail.com",
        "password": "password1"
    }' \
    localhost:8080/users
