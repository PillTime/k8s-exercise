#!/bin/sh

[ ! -f 'token.txt' ] && printf 'missing token file. please run the login script.\n' && exit 1

curl \
    -X PUT \
    -H "Authorization: Bearer $(cat token.txt)" \
    -H 'Content-Type: application/json' \
    -d '{
        "title": "A New Post With A Different Title",
        "author_id": 1,
        "content": "The content of the new post."
    }' \
    localhost:8080/posts/3
