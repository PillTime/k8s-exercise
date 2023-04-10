#!/bin/sh

[ ! -f 'token.txt' ] && printf 'missing token file. please run the login script.\n' && exit 1

curl \
    -X DELETE \
    -H "Authorization: Bearer $(cat token.txt)" \
    localhost:8080/users/3
