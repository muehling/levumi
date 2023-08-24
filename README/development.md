# Development of Levumi

This sections contains information about how to set up the project locally for development.

## Prerequisites

The setup uses Docker and docker-compose. Please refer to the respective installation instructions provided here

https://docs.docker.com/get-docker/

and here

https://docs.docker.com/compose/install/

This manual focuses on using the command line, but it should also be possible to use Docker Desktop.

Setting up the project locally should be also possible, but is not tested. You'd need at least

- Ruby 3.1.2 or later
- yarn
- Node.js 18 or later
- a MySql 8 server

## Initial Setup

If you have not yet run Levumi locally, please follow the following steps.

1. clone the repository
2. change into the project root folder
3. build the containers locally from the terminal: `sudo docker-compose build`
4. start the containers: `sudo docker-compose up`
5. open a new terminal, and enter the `web` container: `sudo docker-compose exec web bash`
6. install the node modules: `yarn`
7. create the database: `rails db:create`
8. then create the database structure: `rails db:migrate`
9. if you need some basic sample data, run `rails db:seed`
10. access the application in the browser of your choice at `localhost:3000`
11. among other stuff, the seed data contains two users you can use to log in: `admin@admin.de` and `user@user.de`, both with the password `123`
12. some example tests are available in `db/example_tests/`. Admin users can import these from "Testverwaltung"

## Development

Once the containers have been built, the project can simply be started with `sudo docker-compose up`
In the browser, the development environment is marked as `DEV` in a red box in the header, to avoid confusion.

### Project Structure

Levumi is a hybrid Rails 7/Vue 2 application. The directory tree is that of a regular Rails 7 application, the frontend is located in `app/frontend`.

#### Rails

Rails is mostly used for API access. The two notable execptions are the frontpage, and the test page for students. The latter is somewhat special, as it is comprised of some classic Rails rendering, as well as the HTML, CSS and Javascript files from the test itself.

#### Vue

Most of the application is implemented as a Vue 2 app. Bootstrap is used heavily, mostly via the `bootstrap-vue` package. Unfortunately, `bootstrap-vue` currently only supports Bootstrap 4, so no Bootstrap 5 goodness is available.

### Writing New Code

Levumi uses Vite as bundler for development purposes. File changes are watched, and are usually applied directly to the running app, without any need to reload the application manully. In rare cases when this does not happen, simply refresh the browser.

### Linting and Prettying

The repository provides configurations for both Prettier and ESLint. Please configure your editor with the required plugins. The code should adhere to the rules of both, if it is to be checked into the repository.

### Databases

#### Access to the Rails console

If needed, you can access the Rails console in the `web` container:

```
sudo docker-compose exec web bash
rails c
```

#### Direct Access to the Database

Usually, it should not be necessary to access the database directly. It is usually better (and safer) to make any data changes via the Rails console.

If really necessary, the database container can be entered with

```
sudo docker-compose exec db bash
```

Inside the container, you have access to the MySQL CLI:

```
mysql -u <username> -p
```

Username and password can be read from the `docker-compose.yml`

#### Working with multiple databases

If you need different databases (e. g. a small one for daily development purposes, and a different one with a production dump), these can easily be switched:

- stop everything: `sudo docker-compose down`
- in the `docker-compose.yml`, change the name of the `MYSQL_DATABASE` in the `environment` of the `db` service
- the same name needs to be put into `config/database.yml` under `development -> database`
- restart everything: `sudo docker-compose up`
  If the database does not yet exist, it needs to be created (see steps 5-7 in Initial Setup). Then, you can either seed the new database, import a dump, or start with an empty database.

### Adding node modules or ruby gems

Node modules can be added with yarn:
`yarn add some-package`
The node modules folder is mounted into the container, so that new packages _should_ be available directly after installation. If not, please enter the container and install the node modules again

```
sudo docker-compose exec web bash
yarn
```

Note that this changes the ownership of the node_modules folder to the container user, which is usually root.

Ruby gems are installed into the container during container build time. If you need a new gem, please add it manually to the Gemfile, run `bundle install`, and then stop and rebuild your container:

```
sudo docker-compose down
sudo docker-compose build
```
