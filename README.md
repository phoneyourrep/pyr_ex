# PYREx

Elixir/Phoenix umbrella application providing backend services for Phone Your Rep, including the public data API.

## Development

This project depends on Elixir and the Phoenix web framework, and therefore the Erlang runtime. It uses a geo-spatial database to identify the political districts of a given location, and therefore depends on a GIS enabled Postgres (PostGIS) database. The project can be mounted in Docker containers to ease development and deployment in different host environments. One container is used to run the application, and a second hosts the PostGIS database. If you're trying to contribute and have problems with configuration on your machine try running it in Docker instead. [nicbet/docker-phoenix](https://github.com/nicbet/docker-phoenix) was used to Dockerize this project.

The Elixir/Phoenix umbrella project is located inside the `./src` directory.

To start the application with Docker from the root project directory:

```bash
docker-compose up
```

Now navigate to [http://localhost:4000](http://localhost:4000).

Other commands use the shell scripts `./mix` and `./run` for execution in the Docker container. They can be run in the following ways from the root project directory:

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

You may not be able to perform all operations, such as creating database migration files, in the Docker container. Some things may require developing in your host environment, particularly when it comes to manipulating the file system. You may also prefer to work this way if configuration is not a problem in your environment. To do so just `cd src/` to enter the umbrella application directory, and work as normal:

```bash
mix phx.server
iex -S mix
# etc...
```