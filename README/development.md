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

- build the containers locally from the terminal: `docker-compose build`
- start the containers: `docker-compose up`
- open a new terminal, and enter the `web` container: `docker-compose exec web bash`
- in the container, first create the database: `rails db:create`
- then create the database structure: `rails db:migrate`
- if you need some basic sample data, run `rails db:seed`
- access the application in the browser of your choice at `localhost:3000`
- among other stuff, the seed data contains two users you can use to log in: `admin@admin.de` and `user@user.de`, both with the password `123`

## Development

In the browser, the development environment is marked as `DEV` in a red box in the header, to avoid confusion.

### Project Structure

Levumi is a hybrid Rails 7/Vue 2 application. The directory tree is that of a regular Rails 7 application, the frontend is located in `app/frontend`.

#### Rails

Rails is mostly used for API access. The two notable execptions are the frontpage, and the test page for students. The latter is somewhat special, as it is comprised of some classic Rails rendering, as well as the HTML, CSS and Javascript files from the test itself.

#### Vue

Most of the application is implemented as a Vue 2 app. Bootstrap is used heavily, mostly via the `bootstrap-vue` package.

### Writing New Code

Levumi uses Vite as bundler for development purposes. File changes are watched, and are usually applied directly to the running app, without any need to reload the application manully.

### Linting and Prettying

The repository provides configurations for both Prettier and ESLint. Please configure your editor with the required plugins. The code should adhere to the rules of both, if it is to be checked into the repository.

### Access to the Rails console

If needed, you can access the Rails console in the `web` container:

```
docker-compose exec web bash
rails c
```

### Direct Access to the Database

Usually, it should not be necessary to access the database directly. It is usually better (and safer) to make any data changes via the Rails console.

If really necessary, the database container can be entered with

```
docker-compose exec db bash
```

Inside the container, you have access to the MySQL CLI:

```
mysql -u <username> -p
```

Username and password can be read from the `docker-compose.yml`

### Adding node modules or ruby gems

Node modules can be added with yarn:
`yarn add some-package`
The node modules folder is mounted into the container, so that new packages _should_ be available directly after installation. If not, please enter the container and install the node modules again

```
docker-compose exec web bash
yarn
```

Note that this changes the ownership of the node modules folder to the container user, which is usually root.

Ruby gems are installed into the container during container build time. If you need a new gem, please add it manually to the Gemfile, run `bundle install`, and then stop and rebuild your container:

```
docker-compose down
docker-compose build
```

### Troubleshooting
