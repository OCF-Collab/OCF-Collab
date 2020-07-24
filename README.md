
# OCF-Collab


# New Developer Setup
* [Bootstrap 4.5 docs](https://getbootstrap.com/docs/4.5/getting-started/introduction/)
* [Slim view templates](https://rdoc.info/gems/slim/frames)

Dependencies:
- Elasticsearch
- Redis
- Postgres
- NPM & Yarn

1. `bundle install`

2. `cp config/database.yml.example config/database.yml`

3. Setup yarn
  * `yarn install`

4. Setup database and migrate
  * `rake db:create db:migrate db:test:prepare`

5. Run rake db:seed

## Deploying on heroku
Configure to deploy to both staging and production in `.git/config` add heroku to your sources:
```
[remote "heroku"]
        url = https://git.heroku.com/ocf-collab.git
        fetch = +refs/heads/*:refs/remotes/heroku/*
```

Deploy master:
`git push heroku-staging master`

Deploy your branch - for eg:
`git push heroku-staging your-feature-branch:master`



## Reindexing Elasticsearch

`rake searchkick:reindex:all`

# Run you development environment locally

Run your webserver on http://localhost:3000/
`bundle exec rails server`

Run webpacker
`bundle exec bin/webpack-dev-server`

