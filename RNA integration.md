# OCF Collab RNA integration

## Authentication

In order to access OCF Collab directory all API calls have to be authenticated using [OAuth 2.0 Client Credentials grant type](https://oauth.net/2/grant-types/client-credentials/).

OAuth 2.0 Client ID and Client secret credentials are provided by OCF Collab for each partner separately.

### Obtaining Access Token

Issue the following request including `client_type`, `client_id` and `client_secret` parameters using `application/json` or `application/x-www-form-urlencoded` payload.

```
# POST https://registry.ocf-collab.org/oauth/token

curl --request POST \
  --url 'https://registry.ocf-collab.org/oauth/token' \
  --header 'Content-Type: application/json' \
  --data '
    {
      "grant_type": "client_credentials",
      "client_id":"ZPbYYq4xCvChzA7o6N6gtR8Va1M6q67PlojScBjAB_Q",
      "client_secret":"525A7_M57-iTsUgXSm19DZ9Y7n51h8paJUP_EE2MV3A"
    }
  '
```

#### Sample response

```
{
  "access_token": "eyJraWQiOiJaUGJZWXE0eEN2Q2h6QTdvNk42Z3RSOFZh...",
  "token_type": "Bearer",
  "expires_in": 600,
  "created_at": 1602761904
}
```

### Authenticating subsequent requests

Pass obtained Access Token in `Authorization` HTTP header.

```
# GET https://registry.ocf-collab.org/api/competency_frameworks/search

curl --request GET \
  --url 'https://registry.ocf-collab.org/api/competency_frameworks/search' \
  --header 'Authorization: Bearer eyJraWQiOiJaUGJZWXE0eEN2Q2h6QTdvNk42Z3RSOFZh...' \
  --data 'query=cybersecurity' \
  --data 'page=3'
```

## Available endpoints

### Competency frameworks search

Returns metadata of competency frameworks matching provided search query.

#### URL
https://registry.ocf-collab.org/competency_frameworks/search

#### Parameters

| Parameter | Required | Type                            | Description                                                                                                           |
|-----------|----------|---------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| query     | Yes      | String                          | Text query used for searching for competency frameworks based on name, description, keywords and actual competencies. |
| per_page  | No       | Integer (default: 25, max: 100) | Maximum number of returned items on a single page.                                                                    |
| page      | No       | Integer (default: 1)            | Specify page of results in case their number exceeds `per_page` parameter.                                            |

#### Sample response

```
# GET https://registry.ocf-collab.org/competency_frameworks/search?query=cybersecurity?per_page=50&page=2

{
  "search": {
    "query": "cybersecurity",
    "per_page": 50,
    "page": 2,
    "total_results_count": 124,
    "results": [
      {
        "id": "https://credentialengineregistry.org/graph/ce-70958c4e-b0c6-4cf7-ab08-fafe9f205384",
        "title": "NICE Cybersecurity Workforce Framework: Tasks",
        "description": "The National Initiative for Cybersecurity Education (NICE) Cybersecurity Workforce Framework components provide ...",
        "attributionName": "Credential Engine",
        "attributionUrl": "https://credentialengine.org",
        "attributionLogoUrl": "https://ocf-collab.github.io/scratch/registryLogos/CredEngine/logo@2x.png", 
        "providerMetaModel": "https://ocf-collab.org/concepts/f9a2b710-1cc4-4065-85fd-596b3c40906c",
        "registryRights": "https://ocf-collab.org/rights/29905411-553e-4872-9baf-e401dac157d2",
        "beneficiaryRights": "https://credentialengine.org/terms/",
      }, {
        ...
      }, {
        ...
      }
    ]
  }
}

```

### Competency framework metadata

Returns metadata of specific competency framework in OCF Collab registry.

#### URL

https://registry.ocf-collab.org/competency_frameworks/metadata

#### Parameters

| Parameter | Required | Type   | Description                                                       |
|-----------|----------|--------|-------------------------------------------------------------------|
| id        | Yes      | String | ID of specific framework as presented in search results response. |

#### Sample request

```
# GET https://registry.ocf-collab.org/competency_frameworks/metadata?id=https:%2F%2Fcredentialengineregistry.org%2Fgraph%2Fce-70958c4e-b0c6-4cf7-ab08-fafe9f205384

{
  "framework": {
    "id": "https://credentialengineregistry.org/graph/ce-70958c4e-b0c6-4cf7-ab08-fafe9f205384",
    "title": "NICE Cybersecurity Workforce Framework: Tasks",
    "description": "The National Initiative for Cybersecurity Education (NICE) Cybersecurity Workforce Framework components provide ...",
    "attributionName": "Credential Engine",
    "attributionUrl": "https://credentialengine.org",
    "attributionLogoUrl": "https://ocf-collab.github.io/scratch/registryLogos/CredEngine/logo@2x.png", 
    "providerMetaModel": "https://ocf-collab.org/concepts/f9a2b710-1cc4-4065-85fd-596b3c40906c",
    "registryRights": "https://ocf-collab.org/rights/29905411-553e-4872-9baf-e401dac157d2",
    "beneficiaryRights": "https://credentialengine.org/terms/",
  }
}
```

### Competency framework asset file

Returns the asset file of specific competency framework in OCF Collab registry.

This endpoint allows to convert the asset file to desired metamodel using the `metamodel` parameter.

#### URL

https://registry.ocf-collab.org/competency_frameworks/asset_file

#### Parameters

| Parameter | Required | Type   | Description                                                                |
|-----------|----------|--------|----------------------------------------------------------------------------|
| id        | Yes      | String | ID of specific framework as presented in search results response.          |
| metamodel | No       | String | Allows to fetch the competency framework converted to specified metamodel. |

##### `metamodel` attribute available values

| Metamodel | Value                                                                |
|-----------|----------------------------------------------------------------------|
| CTDL/ASN  | https://ocf-collab.org/concepts/f9a2b710-1cc4-4065-85fd-596b3c40906c |
| ASN       | https://ocf-collab.org/concepts/6ad27cff-5832-4b3d-bd3e-892208b80cad |
| CASE      | https://ocf-collab.org/concepts/f63b9a67-543a-49ab-b5ed-8296545c1db5 |

#### Sample request

```
# GET https://registry.ocf-collab.org/competency_frameworks/asset_file?id=https:%2F%2Fcredentialengineregistry.org%2Fgraph%2Fce-70958c4e-b0c6-4cf7-ab08-fafe9f205384&metamodel=https%3A%2F%2Focf-collab.org%2Fconcepts%2Ff63b9a67-543a-49ab-b5ed-8296545c1db5

Returns converted competency framework file.
```
