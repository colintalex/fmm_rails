[![Build Status](https://travis-ci.com/colintalex/fmm_rails.svg?branch=main)](https://travis-ci.com/colintalex/fmm_rails)
[![codecov](https://codecov.io/gh/colintalex/fmm_rails/branch/main/graph/badge.svg?token=C0VHeLGbZi)](https://codecov.io/gh/colintalex/fmm_rails)
[![Known Vulnerabilities](https://snyk.io/test/github/colintalex/fmm_rails/badge.svg)](https://snyk.io/test/github/colintalex/fmm_rails)
[![Maintainability](https://api.codeclimate.com/v1/badges/b307c94e4e20cb7d4eff/maintainability)](https://codeclimate.com/github/colintalex/fmm_rails/maintainability)

# README

## FindMyMarket API, Rails
### Tested with RSpec
This API was developed as backend replacement for the FindMyMarket Web application, which formerly used Node/Express.
Developed from scratch, this API improves on the previous version by implementing background workers for User notifications. 
The API utilizes TDD practices to ensure maximum test coverage and reliable operation.

## Goals

- Utilize API keys for other client usage(open-source, educational)
- Implement ActiveJobs for verifying favorite market accuracy
- Implement SMS/email reminders for upcoming favorite markets
- Provide excellent end result documentation

## Endpoints

### Users
---
### Base URL
```
/api/v1/users
```
---
### New User Endpoint
```
POST /api/v1/users/new
```
Payload
```
{
  name: 'tester',
  email: 'test@test.com',
  password: 'password',
  password_confirmation: 'password'
  }
```
Response
```
{
    "token": <user_token>,
    "exp": "05-26-2021 04:10",
    "user": {
        "data": {
            "id": "8",
            "type": "user",
            "attributes": {
                "id": 8,
                "name": "tester",
                "email": "test223@test.com",
                "favorites": []
            },
            "relationships": {
                "favorites": {
                    "data": []
                }
            }
        }
    }
}
```
---

### Show Single User
```
GET /api/v1/users/<user_id>
```
Headers
```
'Authorization': Bearer <user_token>
```
Payload
```
n/a
```
Response
```
{
    "data": {
        "id": "8",
        "type": "user",
        "attributes": {
            "id": 8,
            "name": "tester",
            "email": "test223@test.com",
            "favorites": []
        },
        "relationships": {
            "favorites": {
                "data": []
            }
        }
    }
}
```
---
### Update Single User
```
PUT /api/v1/users/<user_id>
```
Headers
```
'Authorization': Bearer <user_token>
```
Payload
```
{
  name: ?,
  email: ?,
  password: ?,
  password_confirmation: ?,
  default_location: ?,
}
```
Response (Updated User)
```
{
    "data": {
        "id": "8",
        "type": "user",
        "attributes": {
            "id": 8,
            "name": "tester",
            "email": "test223@test.com",
            "favorites": []
        },
        "relationships": {
            "favorites": {
                "data": []
            }
        }
    }
}
```
---
### Delete Single User
```
DEL /api/v1/users/<user_id>
```
Headers
```
'Authorization': Bearer <user_token>
```
Payload
```
n/a
```
Response
```
{
    "message": "User successfully deleted"
}
```
---
## Local Setup

Clone down repository to your local machine.
```
git clone https://github.com/colintalex/fmm_rails.git
```

Install Dependancies
```
bundle install
```
