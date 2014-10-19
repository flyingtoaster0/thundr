Thundr
======

Thundr is a course catalog for Lakehead University students. It is live at http://thundr.ca, and the main repository for the project is at [flyingtoaster0/thundr](https://github.com/flyingtoaster0/thundr) on Github. You can check out the project's about page at [about page](http://thundr.ca/about/) for more information on the project.

##Getting up and running on Yosemite

1. Try to run bundle install and see if nokogiri fails to install:

```bash
$ cd thundr
$ bundle install
```

If nokogiri fails to install, it's probably because it can't find stupid Postgres for some stupid reason. try `$ gem install pg -v '0.17.0'`, but that'll probably fail saying that it can't find your `pg_config`, and I don't really know anything about computers, so just download the Postgres app for Mac www.postgresapp.com and get back in that terminal window and type.

```bash
$ gem install pg -v '0.17.0' -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/9.3/bin/pg_config
```

And pray that it works. It worked for me (although this took me forever to figure out). Run

```bash
bundle install
```

again, and it'll hopefully work. Now, throw this command into the terminal:

```bash
$ rake db:migrate
```

Now we need to do two things: start the worker (this is the scraper), and start the rails server. Pop these into the ole terminal:

```bash
$ rake jobs:work
```

Open a new tab, and in the same directory run

```bash
$ rails server
```

And bang! You just did the impossible: using anything written in Ruby on the latest Mac OS within 6 months of its release. Hack away! Your thing will be on port 3000 UNLESS YOU'RE ME AND HAVE STUPID METEOR RUNNING THERE today was not good for me.

