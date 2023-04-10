# sample rest api with postgres db running in k8s 

programs needed:
`docker` (also docker service running and user in the docker group)
`kubectl`
`k3d`

run `./start.sh` to run the api,
or read the script and execute the commands one-by-one.

since the api was supposed to just be a sample api,
I just searched for an already existing project in the internet.
the project being used here is taken from:
https://levelup.gitconnected.com/crud-restful-api-with-go-gorm-jwt-postgres-mysql-and-testing-460a85ab7121

---

the app creates the database,
so there's no need to run any SQL scripts.
the database consists of two tables:
- User
- Post

**User** saves each users' id, name, email, password (hashed),
and the timestamps of its creation and latest update.

**Post** saves each users' id, title, content, author's id and name,
and the timestamps of its creation and latest update.

the details of the tables can be seen in the structs `User` and `Post`,
present in the files of the folder `api/models`.

---

once the app and database are running
(check `kubectl get pods`),
you can access it at `localhost:8080`.

there's no frontend, but you can use Postman or curl to test the api.
(the `test` folder contains scripts that use curl to test the api.
i recommend having `jq` installed to format the json responses (`./01-show_users.sh | jq`))
the endpoints are:
- **POST** `/login`, which allows to login as a user (returns a token that lasts 1 hour)
- **GET** `/users`, which shows all users (doesn't need token)
- **GET** `/users/<id>`, which shows a specific user (doesn't need token)
- **POST** `/users`, which allows creating a user (doesn't need token)
- **PUT** `/users/<id>`, which allows updating a user (needs token)
- **DELETE** `/users/<id>`, which allows deleting a user (needs token)
- **GET** `/posts`, which shows all posts (doesn't need token)
- **GET** `/posts/<id>`, which shows a specific post (doesn't need token)
- **POST** `/posts`, which allows creating a post (needs token)
- **PUT** `/posts/<id>`, which allows updating a post (needs token)
- **DELETE** `/posts/<id>`, which allows deleting a post (needs token)
- **GET** `/`, just shows a welcome message (doesn't need token)
the two default users are:
user: 'steven@gmail.com' | pass: 'password'
user: 'luther@gmail.com' | pass: 'password'
