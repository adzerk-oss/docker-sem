# Schema Evolution Manager Docker Image

[Available on Docker Hub](https://registry.hub.docker.com/u/alandipert/sem/) as `alandipert/sem:0.9.12`

[Schema Evolution Manager](https://github.com/gilt/schema-evolution-manager)
(sem) is a Ruby-based tool for developing, deploying, and otherwise
managing PostgreSQL schema.  It is excellent.

This project is a [Docker](https://www.docker.com/) image containing a
`sem` installation.  It is useful primarily because Ruby setup can be
fickle, and because `sem` releases aren't distributed as gems.  It
also includes Ubuntu's `postgresql-client` so you can easily run
`psql` to experiment.

At [Adzerk](http://adzerk.com) we use `sem` together with
[fig.sh](http://www.fig.sh/) to develop, deploy, and manage
applications atop Docker.

## Usage

The image provides the `sem` scripts: `sem-init`, `sem-add`,
`sem-apply`, etc.  However, they are linked to shorter names for
`docker run` usage.

### Docker run

Initialize `sem` in the `sample` repository:

    git init sample
    cd sample
    docker run -t -i -v $PWD:/app alandipert/sem:0.9.12 init --dir . --name sample_db --user postgres

Add a new SQL script, `new.sql`:

    echo "create table tmp_table (id integer)" > new.sql
    docker run -t -i -v $PWD:/app alandipert/sem:0.9.12 add new.sql

### fig.sh

`sem` is much more useful when you have a local development database
to run its scripts against.  You could achieve this yourself by
running PostgreSQL separately via `docker run` and linking the `sem`
and PostgreSQL containers explicitly, or you could use
[fig.sh](http://www.fig.sh/).

`fig` is a tool that lets you run `sem` and PostgreSQL together as
linked Docker containers very easily.

After installing `fig`, copy the included `fig.yml` to your
`sem`-based schema repository.

Then, create a local database to work with:

    fig run sem psql -h db_1 -U postgres sample_db

Next, apply schema to the fresh database:

    fig run sem apply --host db_1 --name sample_db --user postgres

## Differences from native `sem`

Publishing releases using this image must be done slightly differently
than with a native `sem` installation.  You shouldn't run `sem-dist`
without a `--tag` argument because `git` in the container won't be
able to see the remote git repository if it is private.

Instead, to publish a release, you should create a tag on the host:

    git tag -a 0.0.1 -m 'schema release 0.0.1'

And then supply a `--tag` argument to `sem-dist`:

    fig run sem dist --tag 0.0.1
