## Deal-a-Day CSV data loading tool

### Introduction

First of all, thanks for reading this! Secondly, sorry if I diverged too much from
the project plan.

I spend a lot of time working on a very complicated file import flow at my current job, and wanted to take this opportunity
to try a bit of a different approach, and hopefully show some cool code in the process.

I did not do strict TDD for this, but made sure to keep up good unit tests at regular intervals.
I was really happy about how this led my design to small classes with clear responsibilities.

I've implemented a denormalized schema that uses Github authorization for upload,
accepts CSV and TSV files (although I was not succesful with a CSV generated by excel on my mac),
and has index views of all the models. I did not implement sign in with email, as it seemed redundant with
the GithHub Authorization.

After looking at the example data, I chose a schema with 4 models:

- Merchant
- Customer
- Item
- Purchase

I decided that even though the data suggested that the items could be sold by different
merchants, it seemed more likely that a merchant would have their own deals, so I made
the Items unique by name and price per merchant.

A common pitfall in this case would be to either create duplicate data, or execute several
lookup queries per row.

To solve this I created an in-memory cache system that holds on to the id's of records
it has seen before. This way there is only a single lookup for each distinct record.

Thank you for your consideration!  -- Alex Berry

#### Limitations:

- Memory: A lot of temporary objects are created in the process, so GC or total memory use may become an issue with very large files
  - Could chunk the import by some reasonable number of lines
  - Some optization could be done to reduce the number of objects created

### Prerequisites
1. Postgres database
1. Ruby 2.x

### Google OAuth configuration

- Create a [new Github Oauth application](https://github.com/settings/applications/new)
  - Homepage URL: http://localhost:3000/
  - Authorization callback URL: http://localhost:3000/
- Export the github application keys on your local machine: (replace client_id and client_secret with values from github application page)

```
export GITHUB_KEY=CLIENT_ID
export GITHUB_SECRET=CLIENT_SECRET
```

### Installation instructions
- Copy this project folder to your local machine
- From this directory on your machine run the following commands:

```
bundle install
bundle exec rake db:drop db:create db:migrate db:test:prepare
rails s
```

The running app should be available at: [http://localhost:300/](http://localhost:300/)

### Running tests
There is a unit test suite for all of the custom code. To run the full suite:

```
bundle exec rake
```

individual tests can be run with:

```
bundle exec rspec spec/path_to_spec/some_spec.rb
```

### Resetting the DB
Because the index views don't have any pagination, importing a very large file
may make those pages unusable. To reset your database, run these commands:

```
rake db:drop db:create db:migrate
```
