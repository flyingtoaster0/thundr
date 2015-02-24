Thundr
======

Thundr is a course catalog for Lakehead University students. It is live at http://thundr.ca, and the main repository for the project is at [flyingtoaster0/thundr](https://github.com/flyingtoaster0/thundr) on Github. You can check out the project's about page at [about page](http://thundr.ca/about/) for more information on the project.

####Getting up and running

1. Try to run bundle install and see if nokogiri fails to install:

```bash
$ cd thundr
$ bundle install
```

If nokogiri fails to install, it's probably because it can't find Postgres on your machine. Try `$ gem install pg -v '0.17.0'`. If that fails with a message indicating that it can't fing your `pg_config`, then the easiest fix is just to download the Postgres app for Mac www.postgresapp.com, and run the install command with the path to your Postgres install specified. 

```bash
$ gem install pg -v '0.17.0' -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/9.3/bin/pg_config
```

And pray that it works. It worked for me (although this took me forever to figure out). Run

```bash
bundle install
```

again, and it'll hopefully work. Run:

```bash
$ rake db:migrate
```

Now we need to do two things: start the worker (this is the scraper), and start the rails server.

```bash
$ rake jobs:work
```

Open a new tab, and in the same directory run

```bash
$ rails server
```
