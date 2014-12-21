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

## Location Gems

We use [RGeo](https://github.com/rgeo/rgeo) with the [AR Postgis adapter](https://github.com/rgeo/activerecord-postgis-adapter#creating-spatial-tables).

## API Design guide

Try to make things easy.

Remember to only return useful error messages if authorised.
Otherwise you're creating security issues.

Test all code. It's a pain in the ass to have untested code around.
Ruby is too easy to not write untested code.

## API

Prepend everything with `/api/v1`

### Current User

#### `post /location/:x:y:z:m`

Set location x, y, z (optional), m (optional) of current user.

Pre-auth implementation: add param `id` to specify user.

#### `get /location`

Get last stored location of current user.

Pre-auth implementation: add param `id` to specify user.

#### `get /friends`

Get friends of current user.

### Users

#### `get /users/:id`

Returns user with :id.

#### `get /users`

Returns all users.

#### `post /users`

Creates a user.

Params:

- first_name
- last_name
- email

#### `put /users/:id`

Update a user.

#### `delete /users/:id`

Delete a user.
