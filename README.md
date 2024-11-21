# README

## Starting the Containerized Rails App

To start the containerized Rails application, follow these steps:

1. Build the Docker image:
  ```sh
  docker-compose build
  ```

2. Run the Docker containers:
  ```sh
  docker-compose up -d
  ```
3. Create the database:
  ```sh
  docker-compose run web rails db:create
  ```
4. Run the migrations:
  ```sh
  docker-compose run web rails db:migrate
  ```
5. Access the apis at `http://localhost:3000`.