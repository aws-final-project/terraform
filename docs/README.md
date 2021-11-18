# User Profile Service

Service that holds all the user account and profile information for the registered users of Find My Taco.
- GET* all users: fmt-profiles.galvanizelabs.net/admin/users
- GET single user: fmt-profiles.galvanizelabs.net/users/{username}
- PATCH* single user (lock/unlock): fmt-profiles.galvanizelabs.net/admin/users/{username}/update-lock
- PATCH single user (modify user details): fmt-profiles.galvanizelabs.net/users/{username}/update
- GET pre-signed URL S3 bucket (upload profile picture): fmt-profiles.galvanizelabs.net/users/generate/s3-url
<br> *Requires admin authentication all others require at least user authentication

[Authenticaton is required for all endpoints.](https://gitlab.com/stfa-cnd-08-2021/capstone/glab-idp-service/-/blob/main/README.md)

## Documentation
- [UserProfile_openapi.json](https://gitlab.com/stfa-cnd-08-2021/capstone/user-accounts-profiles/-/blob/master/user-account-swagger.yml)

## To run locally

- Install and create MySQL database
- Create the following environment variables in the current session
    ```bash
    DB_HOST=localhost:3306
    DB_NAME=<local db name>
    DB_USER=<local db user>
    DB_PWD=<local db password>
    JWT_SECRET_KEY=jwtSecretKey
    ```
- Build and run
- Server should be running on port 8080 by default

## Microservice repo
- [User Account and Profile repo](https://gitlab.com/stfa-cnd-08-2021/capstone/user-accounts-profiles)

## Team memember responsiblities and roles
All three team memebers (Christopher, Casey and Tod) shared all responsibilities and roles over the course of the 4 sprints of project time.  Each member took turns acting and scrum master, leading daily stand-ups and weekly retros.  We took turns driving while the other two members navigated and googled when necessary.

