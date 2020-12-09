# Request Broker

## Goal

The goal of Request Broker service is to be an intermediary between Requesters and Providers within the OCF Collab network serving couple of purposes:

* Authenticate requests and make sure they come from authorized Requesters
* Allow Requesters to search for competency frameowks across the whole network
* Allow Requester Node Agents to fetch competency frameworks from multiple providers using single, common API
* Enable Requesters to receive competency frameworks in desired metamodel via Metamodel Interchange
* Collect Transaction Log allowing insight into nodes usage pattern


## Node Directories

Node Directory, represented by `NodeDirectory` database model, is a collection of competency frameworks exposed to the network by specific provider. Competency frameworks are represented by Node Directory Entry files in a specified S3 bucket within configured AWS account.

Current list of node directoties is maintained within `config/registry_directory.json` file present in this repository.

In order to ensure proper configuration in the database run `registry_directory:sync_from_file` Rake task.

### AWS configuration

Use `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_REGION` environment variables to specify access credentials for S3 buckets assigned to Node Directories.


## Request Node Agents

All requests come from Request Node Agents which are the end user access points for searching and retrieving competency frameworks.

Specific Request Node Agents are authenticated using [OAuth 2.0 protocol](https://oauth.net/2/) with [JWT](https://jwt.io/introduction/) tokens and Request Broker serves as an identity provider.

Request Broker doesn't authenticate specific end users and instead uses [Client Credential flow](https://oauth.net/2/grant-types/client-credentials/) for application based authentication.

### Adding Request Node Agents

In order to enable Request Node Agent access to the network `OauthApplication` record has to be created.

THe only required attribute is `name`. `uid` and `secret`, which serve as OAuth 2.0 client credentials are generated automatically.

Specify `node_directory` association if the Request Node Agent belongs to a node member that also exposes its own directory to the network. The association is used only for insight within Transaction Log.

### JWT tokens


