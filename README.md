# README

THE PROJECT MANAGEMENT TOOL CHALLENGE

## Technologies

* Ruby 2.7.1
* Rails 6.1.4
* Postgres 12.7

## Development with Docker

Building api image:
```sh
  docker-compose build
```

Setting the database up:
```sh
  docker-compose run api rake db:create
  docker-compose run api bin/setup
```

Running the app:
```sh
  docker-compose up
```

Running the specs:
```sh
  docker-compose run api rspec
```

