# Checkin Service

Creating a check-in service using Napa

This is a check-in service that allows Users to check into a Business. Built with [Napa](https://github.com/bellycard/napa).

## Setup

```
git clone git@github.com:shaqq/checkin-service.git
cd checkin-service
bundle install
rake db:create
rake db:migrate
```

## Getting Started

```
shotgun
```

This will run the check-in service at http://localhost:9393. Make sure to set your [`HEADER_PASSWORDS`](#security)

And then try:

1. [Creating a User](https://github.com/shaqq/checkin-service#users)
2. [Creating a Business](https://github.com/shaqq/checkin-service#businesses)
3. [Checkin to the Business with the User](https://github.com/shaqq/checkin-service#checkins)

### Models

The Checkin Service has three models: [User](https://github.com/shaqq/checkin-service#users), [Business](https://github.com/shaqq/checkin-service#businesses), and a join model [Checkin](https://github.com/shaqq/checkin-service#checkins)

A [User](https://github.com/shaqq/checkin-service#users) has three required attributes:
- `name`
- `email`
- `password`

And a password_confirmation is needed on creation.

A [Business](https://github.com/shaqq/checkin-service#businesses) has one required attribute:
- `name`

It also has a notion of a `checkin_lock_time`. After a [User](https://github.com/shaqq/checkin-service#users) checks in, the [User](https://github.com/shaqq/checkin-service#users) can only checkin again after the `checkin_lock_time` has passed. This can be set on a per-business basis, or a default one can be set in the `CHECKIN_LOCK_TIME` env variable.

A [Checkin](https://github.com/shaqq/checkin-service#checkins) has two required attributes:
- `user_id`
- `business_id`

### Security

Currently, the check-in service uses [Napa's authentication middleware](https://github.com/bellycard/napa#authentication).

By setting `HEADER_PASSWORDS='sosecret,tooninja'` in your `.env` file, you'll be able to use those passwords as basic authentication keys in your request headers.

As the service grows, a system to manage API keys would need to be built.

### Specs

Setup your test environment and run your tests:

```
RACK_ENV=test rake db:create
RACK_ENV=test rake db:migrate
rspec spec
```

## API Documentation

### Users

Create a user at `/users`

```
curl -X POST
  --header 'Password: sosecret'
  -d name='Eric Clapton'
  -d email='cream@gmail.com'
  -d password='sunshine'
  -d password_confirmation='sunshine'
  http://localhost:9393/users
```

**Response**

```
Status: 201 Created
{
  "data": {
    "object_type": "user",
    "id": "1",
    "name": "Eric Clapton",
    "email": "cream@gmail.com",
    "created_at": "2014-06-16 00:55:41 UTC"
  }
}
```

Get a single user at `/users/:user`

```
curl -X GET
  --header 'Password: tooninja'
  http://localhost:9393/users/1
```

**Response**

```
Status: 200 OK
{
  "data": {
    "object_type": "user",
    "id": "1",
    "name": "Eric Clapton",
    "email": "cream@gmail.com",
    "created_at": "2014-06-16 00:55:41 UTC"
  }
}
```

Get the user's checkins at `/users/:user/checkins`

```
curl -X GET
  --header 'Password: tooninja'
  http://localhost:9393/users/1/checkins
```

**Response**

```
Status: 200 OK
{
  "data": [
    {
      "object_type": "checkin",
      "id": "1",
      "user_id": 1,
      "business_id": 1,
      "created_at": "2014-06-16 00:55:41 UTC"
    },
    {
      ...
    }
  ]
}
```


Update a user at `/users/:user`

```
curl -X PUT
  --header 'Password: tooninja'
  -d name="Jack Bruce"
  http://localhost:9393/users/1
```

**Response**

```
Status: 200 OK
{
  "data": {
    "object_type": "user",
    "id": "1",
    "name": "Jack Bruce",
    "email": "cream@gmail.com",
    "created_at": "2014-06-16 00:55:41 UTC"
  }
}
```

Get a list of users at `/users`

```
curl -X GET
  --header 'Password: sosecret'
  http://localhost:9393/users
```

**Response**

```
Status: 200 OK
{
  "data": [
    {
      "object_type": "user",
      "id": "1",
      "name": "Eric Clapton",
      "email": "cream@gmail.com",
      "created_at": "2014-06-16 00:55:41 UTC"
    },
    {
      ...
    },
  ]
}
```

You can get the most up to date documentation at the `/swagger_doc` endpoint:

```
curl -X GET
  --header 'Password: sosecret'
  http://localhost:9393/swagger_doc/users.json
```

### Businesses

Create a business at `/businesses`

```
curl -X POST
  --header 'Password: sosecret'
  -d name='Run Dis Biz'
  http://localhost:9393/businesses
```

**Response**

```
Status: 201 Created
{
  "data": {
    "object_type": "business",
    "id": "1",
    "name": "Run Dis Biz",
    "checkin_lock_time": 60.0,
    "created_at": "2014-06-16 00:55:41 UTC"
  }
}
```

Get a single business at `/businesses/:business`

```
curl -X GET
  --header 'Password: tooninja'
  http://localhost:9393/businesses/1
```

**Response**

```
Status: 200 OK
{
  "data": {
    "object_type": "business",
    "id": "1",
    "name": "Run Dis Biz",
    "checkin_lock_time": 60.0,
    "created_at": "2014-06-16 00:55:41 UTC"
  }
}
```

Get the business's checkins at `/businesses/:business/checkins`

```
curl -X GET
  --header 'Password: tooninja'
  http://localhost:9393/businesses/1/checkins
```

**Response**

```
Status: 200 OK
{
  "data": [
    {
      "object_type": "checkin",
      "id": "1",
      "user_id": 1,
      "business_id": 1,
      "created_at": "2014-06-16 00:55:41 UTC"
    },
    {
      ...
    }
  ]
}
```

Get a list of users that checked into the business at `/businesses/:business/customers`

{"unique": true} gets a unique list of users

```
curl -X GET
  --header 'Password: tooninja'
  -d unique=true
  http://localhost:9393/businesses/1/customers
```

**Response**

```
Status: 200 OK
{
  "data": [
    {
      "object_type": "user",
      "id": "1",
      "name": "Eric Clapton",
      "email": "cream@gmail.com",
      "created_at": "2014-06-16 00:55:41 UTC"
    },
    {
      ... (other unique users)
    }
  ]
}
```


Update a business at `/businesses/:business`

```
curl -X PUT
  --header 'Password: tooninja'
  -d name="Da Biz Haz Been Run"
  -d checkin_lock_time=30.0
  http://localhost:9393/businesses/1
```

**Response**

```
Status: 200 OK
{
  "data": {
    "object_type": "business",
    "id": "1",
    "name": "Da Biz Haz Been Run",
    "checkin_lock_time": 30.0,
    "created_at": "2014-06-16 00:55:41 UTC"
  }
}
```

Get a list of businesses at `/businesses`

```
curl -X GET
  --header 'Password: sosecret'
  http://localhost:9393/businesses
```

**Response**

```
Status: 200 OK
{
  "data": [
    {
      "object_type": "business",
      "id": "1",
      "name": "Run Dis Biz",
      "checkin_lock_time": 60.0,
      "created_at": "2014-06-16 00:55:41 UTC"
    },
    {
      ...
    },
  ]
}
```

You can get the most up to date documentation at the `/swagger_doc` endpoint:

```
curl -X GET
  --header 'Password: sosecret'
  http://localhost:9393/swagger_doc/businesses.json
```

### Checkins

Create a checkin at `/checkins`

```
curl -X POST
  --header 'Password: sosecret'
  -d user_id=1
  -d business_id=1
  http://localhost:9393/checkins
```

**Response**

```
Status: 201 Created
{
  "data": {
    "object_type": "checkin",
    "id": "1",
    "user_id": 1,
    "business_id": 1,
    "created_at": "2014-06-16 00:55:41 UTC"
  }
}
```

Get a single checkin at `/checkins/:checkin`

```
curl -X GET
  --header 'Password: tooninja'
  http://localhost:9393/checkins/1
```

**Response**

```
Status: 200 OK
{
  "data": {
    "object_type": "checkin",
    "id": "1",
    "user_id": 1,
    "business_id": 1,
    "created_at": "2014-06-16 00:55:41 UTC"
  }
}
```

Get a list of checkins at `/checkins`

```
curl -X GET
  --header 'Password: sosecret'
  http://localhost:9393/checkins
```

**Response**

```
Status: 200 OK
{
  "data": [
    {
      "object_type": "checkin",
      "id": "1",
      "user_id": 1,
      "business_id": 1,
      "created_at": "2014-06-16 00:55:41 UTC"
    },
    {
      ...
    },
  ]
}
```

You can get the most up to date documentation at the `/swagger_doc` endpoint:

```
curl -X GET
  --header 'Password: sosecret'
  http://localhost:9393/swagger_doc/checkins.json
```


## TODO:
- Add OAuth2 with something like [rack-oauth2](https://github.com/nov/rack-oauth2)
- Create a wiki page for each endpoint
- Get checkins by datetime (See [#1](https://github.com/shaqq/checkin-service/pull/1))
- Define `checkins` endpoint a little clearer
