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

This will run the check-in service at http://localhost:9393. Make sure to set your [`HEADER_PASSWORDS`](https://github.com/shaqq/checkin-service#security)

## Security

Currently, the check-in service uses [Napa's authentication middleware](https://github.com/bellycard/napa#authentication).

By setting `HEADER_PASSWORDS='sosecret,tooninja'` in your `.env` file, you'll be able to use those passwords as basic authentication keys in your request headers.

As the service grows, a system to manage API keys would need to be built.


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

### Checkins

## Specs

Setup your test environment and run your tests:

```
RACK_ENV=test rake db:create
RACK_ENV=test rake db:migrate
rspec spec
```

## TODO:
- Add OAuth2 with something like [rack-oauth2](https://github.com/nov/rack-oauth2)
- Create a wiki page for each endpoint
- Get checkins by datetime (See [#1](https://github.com/shaqq/checkin-service/pull/1))
- Define `checkins` endpoint a little clearer