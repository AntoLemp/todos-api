# Our API will expose the following RESTful endpoints.
| Endpoint                |               Functionality |
|:------------------------|----------------------------:|
| POST /signup            |                      Signup |
| POST /auth/login        |                       Login |
| GET /auth/logout        |                      Logout |
| GET /todos              |              List all todos |
| POST /todos             |           Create a new todo |
| GET /todos/:id          |                  Get a todo |
| PUT /todos/:id          |               Update a todo |
| DELETE /todos/:id       | Delete a todo and its items |
| GET /todos/:id/items    |             Get a todo item |
| PUT /todos/:id/items    |          Update a todo item |
| DELETE /todos/:id/items |          Delete a todo item |

- Ruby version: 3.4.8
- Rails version: 8.1.2
- Database: SQLite3