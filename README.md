# PYREx

Elixir/Phoenix umbrella application providing backend services for Phone Your Rep, including the public data API.

## Development

This project depends on Elixir and the Phoenix web framework, and therefore the Erlang runtime. It uses a geo-spatial database to identify the political districts of a given location, and therefore depends on a GIS enabled Postgres (PostGIS) database. The project can be mounted in Docker containers to ease development and deployment in different host environments. One container is used to run the application, and a second hosts the PostGIS database. If you're trying to contribute and have problems with configuration on your machine try running it in Docker instead. [nicbet/docker-phoenix](https://github.com/nicbet/docker-phoenix) was used to Dockerize this project.

To start the application:

```bash
docker-compose up
```

Now navigate to [http://localhost:4000](http://localhost:4000).

Other commands use the shell scripts `./mix` and `./run` for execution in the docker container. They can be run in the following ways:

### Mix tasks
Run the script with `./mix` instead of the standard `mix` call.

```bash
./mix test
```

### General commands
Call other commands with the script `./run`.

```bash
./run iex -S mix
```

With this repository cloned to your machine and Docker installed, start by creating, migrating, and seeding the database.

```bash
./mix ecto.create
./mix ecto.migrate
./mix run priv/repo/seeds.exs
```

Now run the tests and start the server

```bash
./mix test
docker-compose up
```