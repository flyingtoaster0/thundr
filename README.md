Thundr
======

Thundr is a course catalog for Lakehead University students. It is live at http://thundr.ca, and the main repository for the project is at [flyingtoaster0/thundr](https://github.com/flyingtoaster0/thundr) on Github. You can check out the project's about page at [about page](http://thundr.ca/about/) for more information on the project.

Overview
=========

For the most part, Thundr functions by using web scraping [web scrapers](http://en.wikipedia.org/wiki/Web_scraping) to pull data from the Lakehead University webside into the database. The data is then available through the website through the Rails framework. Currently, this works by having the application visit the [fall/winter timetables page](http://timetable.lakeheadu.ca/2013FW_UG_TBAY/) and grabs every link that leads to a timetable for a department. Those links are followed, and then the course information is grabbed from the pages returned by them. The website itself is actually quite simple. It simply acts an an interface for users to view the stored information (though more features are still being added :) )
