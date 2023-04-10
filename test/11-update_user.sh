#!/bin/sh

[ ! -f 'token.txt' ] && printf 'missing token file. please run the login script.\n' && exit 1

curl \
    -X PUT \
    -H "Authorization: Bearer $(cat token.txt)" \
    -H 'Content-Type: application/json' \
    -d '{
        "nickname": "New Name",
        "email": "e@mail.com",
        "password": "password1"
    }' \
    localhost:8080/users/3
