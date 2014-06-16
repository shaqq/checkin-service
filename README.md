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


Update a business at `/businesses/:business`

```
curl -X PUT
  --header 'Password: tooninja'
  -d name="Da Biz Haz Been Run"
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