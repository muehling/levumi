# Deployment

This section contains information about the server environment, and how to deploy Levumi to either the staging or the production environment.

## Servers

Both the production and the staging systems of Levumi are hosted on `ruapehu.informatik.uni-kiel.de`. Please contact the repository owner if you need access the server directly.

The applications can be accessed under `levumi.de` (production) and `staging.levumi.de` (staging).

## Dokku

Levumi is configured to deploy to both servers using Gitlab pipelines and Dokku. Automatic deployments will only work in the Gitlab of the Institut für Informatik. The Github version is only a mirror, and is intended to be used by users who are not members of the CAU.
The dokku apps are called `levumi2-prod` for the production system and `levumi2-staging` for the staging system.

### Database connections

The database connections are entirely managed by Dokku and should be of no concern to the user. The access data is stored in environment variables in the respective containers. Manual changes to the databases in both environments can be done with the Rails console in the application container (`sudo` privileges are required):

```
dokku enter levumi2-prod
rails c
```

Direct access to the database is rarely (if ever) necessary. Should the need really arise, you can open a MySQL CLI in the database container as follows:

```
dokku mysql:enter levumi2-prod_db
mysql -u <username> -p
```

The necessary credentials can be pulled from the environment variables in the application container:

```
dokku enter levumi2-prod
env | grep DOKKU_MYSQL
```

But as said, it shouldn't be necessary, is generally dangerous, and it is easier (and safer) to change data with the Rails console. **Also, always create a backup of the database before you attempt any manual changes!**

### Staging deployment

To deploy to the staging environment, merge your feature branch onto the `staging` branch and push it into the repository:

```
git checkout staging
git pull
git merge feature/my_cool_feature --no-ff
git push
```

The will trigger a Gitlab pipeline that will run the deployment; you can sit back with a coffee, and watch console output scrolling by for a couple of minutes. Afterwards, check `staging.levumi.de` if your feature (and everything else) is (still) working as intended. The staging environment is marked as "TEST-UMGEBUNG" in the header to avoid confusion.

Please note: the staging system is used only for testing purposes, or showing new features to other project members for evaluation. It can be reset at any time without notification.

### Production deployment

To deploy to the production environment, a few additional steps are necessary.

First, run the tests locally:

```
docker-compose up
docker-compose exec web bash
rails test
```

If the tests fail, please check why, fix the errors, or adapt the tests accordingly.

Check if there are outdated or vulnerable node_modules:

```
yarn audit
```

Please update any vulnerable dependencies in the package.json (and run `yarn` to update the yarn.lock as well) before progessing.

Afterwards, merge your feature first into `develop`, then merge `develop` into `master`:

```
git checkout develop
git pull
git merge feature/my_cool_feature --no-ff
git push
git checkout master
git pull
git merge develop --no-ff
git push
```

As with `staging`, the push to `master` will trigger a Gitlab pipeline that will automatically attempt to deploy the code to the production environment. If the deployment succeeded, please check levumi.de if everything still works as intended. If the deployment fails, no harm is done - the system will simply use the previous container.

### Maintenance Mode

For server or database maintenance tasks, Levumi can be put into maintenance mode. When in maintenance mode, only a notification page is shown, and only users with the capability `admin` can log in.

The maintenance mode can be activated with

```
dokku config:set levumi2 MAINTENANCE="true"
```

and deactivated again with

```
dokku config:unset levumi2 MAINTENANCE
```
