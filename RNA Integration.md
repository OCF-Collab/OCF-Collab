# OCF Collab integration

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
  --data 'limit=10'
```

## Available endpoints

### Competency frameworks search

Search competency frameworks available in OCF Collab registry.

#### URL
https://registry.ocf-collab.org/competency_frameworks/search

#### Parameters

| Parameter | Required | Type                    | Description                                                                                                           |
|-----------|----------|-------------------------|-----------------------------------------------------------------------------------------------------------------------|
| query     | Yes      | String                  | Text query used for searching for competency frameworks based on name, description, keywords and actual competencies. |
| limit     | No       | Integer (range: 1 - 10) | Maximum number of returned items.                                                                                     |

#### Sample response

```
# GET https://registry.ocf-collab.org/competency_frameworks/search?query=cybersecurity

{
  "search": {
    "query": "cybersecurity",
    "results": [
      {
        "id": "ce-6f48f4bb-9d78-4947-8ab6-4722749f2733",
        "name": "NICE Cybersecurity Workforce Framework: Tasks",
        "description": "The National Initiative for Cybersecurity Education (NICE) Cybersecurity Workforce Framework components provide ...",
        "attributionName": "Credential Engine",
        "attributionUrl": "https://credentialengine.org",
        "attributionLogoUrl": "https://ocf-collab.github.io/scratch/registryLogos/IMS/imslogo.png", 
        "providerMetaModel": "https://ocf-collab.org/concepts/6ad27cff-5832-4b3d-bd3e-892208b80cad",
        "registryRights": "https://ocf-collab.org/rights/29905411-553e-4872-9baf-e401dac157d2",
        "beneficiaryRights": "https://credentialengine.org/terms/",
        "assetDownloadUrl": "https://registry.ocf-collab.org/competency_frameworks/ce-6f48f4bb-9d78-4947-8ab6-4722749f2733/download",
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

Fetch metadata of specific competency framework in OCF Collab registry.

#### URL

https://registry.ocf-collab.org/competency_frameworks/:id

#### Sample request

```
# GET https://registry.ocf-collab.org/competency_frameworks/ce-6f48f4bb-9d78-4947-8ab6-4722749f2733

{
  "framework": {
    "id": "ce-6f48f4bb-9d78-4947-8ab6-4722749f2733",
    "name": "NICE Cybersecurity Workforce Framework: Tasks",
    "description": "The National Initiative for Cybersecurity Education (NICE) Cybersecurity Workforce Framework components provide ...",
    "attributionName": "Credential Engine",
    "attributionUrl": "https://credentialengine.org",
    "attributionLogoUrl": "https://ocf-collab.github.io/scratch/registryLogos/IMS/imslogo.png", 
    "providerMetaModel": "https://ocf-collab.org/concepts/6ad27cff-5832-4b3d-bd3e-892208b80cad",
    "registryRights": "https://ocf-collab.org/rights/29905411-553e-4872-9baf-e401dac157d2",
    "beneficiaryRights": "https://credentialengine.org/terms/",
    "assetDownloadUrl": "https://registry.ocf-collab.org/competency_frameworks/ce-6f48f4bb-9d78-4947-8ab6-4722749f2733/download"
  }
}
```

### Competency framework download

Download specific competency framework in OCF Collab registry.

#### URL

https://registry.ocf-collab.org/competency_frameworks/:id/download

#### Parameters

| Parameter | Required | Type   | Description                                                                |
|-----------|----------|--------|----------------------------------------------------------------------------|
| metamodel | No       | String | Allows to fetch the competency framework converted to specified metamodel. |

#### Sample request

```
# GET https://registry.ocf-collab.org/competency_frameworks/ce-6f48f4bb-9d78-4947-8ab6-4722749f2733/download?metamodel=ctdl

Returns converted competency framework file.
```
