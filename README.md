# Therewhere API

## Setup

1. Develop on Mac OSX Yosemite or later
1. Use ruby 2.1.5
1. Use http://postgresapp.com/ for Postgres. It includes Postgis, which we need.

## Tests

Run tests automatically with:

```
bundle exec guard
```

Leave it open. It will run on changes.

## API

Preprend everything with `/api/v1`

### Users

#### get `/users/:id`

Returns user with :id.

#### get `/users`

Returns all users.

#### post '/users'

Creates a user.

Params:

- first_name
- last_name
- email

### put '/users/:id'

Update a user.

### delete '/users/:id'

Delete a user.
