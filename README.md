# OCF-Collab
[https://www.ocf-collab.org/](https://www.ocf-collab.org/)

## Import Node Directory and Registry Directory Files

` `
`rake searchkick:reindex:all`

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

## API Credentails & ENV Variables

App secrets/credentials:
1. Ensure you have a copy of `touch config/master.key` locally (Check Heroku ENV vars)
2. Edit your credentials with `EDITOR=nano bundle exec bin/rails credentials:edit`

## Project Terminology
[Glossary](https://docs.google.com/document/d/1jwAhm8LhsEgQsbcMz0SJZmcJlTTu8iunY8SZaryNBTk/edit)

Acronyms:
```
RNA User = Request Node Agent User
RNA = Request Node Agent
RB = Request Broker
PNA = Provider Node Agent
OCF = Open Competency Framework
MI / Metamodel Interchanger = The service that takes the provider’s framework instance that has been modeled using one metamodel and transforms it into the requester’s prefered metamodel.

CER -> CTDL/ASN
IMS -> CASE
D2L -> ASN
```

Registries:

```
CER = Credential Engine Registry
IMS = IMS Global CASE Network
D2L = Desire2Learn (D2L) Competency Registry
```

Registry -> Language/Vocab Mappings:

```
CER -> CTDL/ASN
IMS -> CASE
D2L -> ASN
```
