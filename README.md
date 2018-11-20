Thundr
======

Thundr is a course catalog for Lakehead University students. It is live at http://thundr.ca, and the main repository for the project is at [flyingtoaster0/thundr](https://github.com/flyingtoaster0/thundr) on Github. You can check out the project's about page at [about page](http://thundr.ca/about/) for more information on the project.

Overview
========

For the most part, Thundr functions by using web scraping web scrapers to pull data from the Lakehead University webside into the database. The data is then available through the website through the Rails framework. Currently, this works by having the application visit the fall/winter timetables page and grabs every link that leads to a timetable for a department. Those links are followed, and then the course information is grabbed from the pages returned by them. The website itself is actually quite simple. It simply acts as an interface for users to view the stored information (though more features are still being added :) )

Contributing
============

Contributions are welcome to this project (especially from Lakehead students). Before you begin development, you'll need to install a few things.

####Prerequisites

- Git - There are a ton of different ways to get Git, and it varies per platform. If you're on a mac, the easiest way is to install [Xcode](https://developer.apple.com/xcode/) (which you've probably already done), and install Xcode's command line developer tools. To do this, open up a terminal, run the command `gcc`, and you'll be prompted to install the command line developer tools.
- [Ruby](https://www.ruby-lang.org/)
- [Ruby on Rails](http://rubyonrails.org/)
- [Postgres](http://www.postgresql.org/), **or for Mac users,** [Postgres](http://postgresapp.com/)

####Getting up and running

First, you'll need to install all the project dependencies. Try to run `bundle install` and see if nokogiri fails to install:

```bash
$ cd thundr
$ bundle install
```

If the gem 'nokogiri' fails to install, it's probably because it can't find Postgres on your machine. Try `$ gem install pg -v '0.17.0'`. If that fails with a message indicating that it can't find your `pg_config`, then the easiest fix is just to download the Postgres app for Mac www.postgresapp.com, and run the install command with the path to your Postgres install specified. 

```bash
$ gem install pg -v '0.17.0' -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/9.3/bin/pg_config
```

And pray that it works. It worked for me (although this took me forever to figure out). Run

```bash
bundle install
```

again, and it'll hopefully work. Start Postgres from somewhere (if you've installed the Mac app, it's as easy as starting the Postgres aplication), and run:

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

####My changes

- Completely new layout
- Added a label for full-year courses
- Setup click-to-copy for course synonyms
