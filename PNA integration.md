# OCF Collab PNA integration

Provider Node Agent (PNA) is a service which purpose is to validate that requests come from OCF Collab network and expose a common API that allows to fetch a competency framework based on `id` provided by the network node in registry entry fiels.

## Authenticating requests

Before Request Node Agent (RNA) is able to search or request specific competency framework from the OCF Collab network it's required to authenticate with identity provider using [OAuth 2.0 Client Credentials flow](https://oauth.net/2/grant-types/client-credentials/).

The authentication results in issued [JWT](https://jwt.io/introduction/) access token which later is forwarded to the PNA with each request coming from Request Broker.

### Accessing the JWT token

The token is attached to HTTP request within `Authorization` header.

```
Authorization: Bearer eyJraWQiOiIxNDJlZjQwYzdjOGY2OTg5ZDNiNjBkMTc0ZDAyMGUzZGJmNGI5ZWI2NjViMGQ0YjBiOWQ0MjNjZGIyY2MwZDhlIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL3JlZ2lzdHJ5Lm9jZi1jb2xsYWIub3JnIiwiaWF0IjoxNjA2ODQ0MzY3LCJleHAiOjE2MDY4NDQ5NjcsImp0aSI6IjNjN2M3MDBmLWQ2NDctNGQ1My04NWY3LTc5ZWU1M2Y0YWM0NyIsInJuYSI6eyJpZCI6MSwibmFtZSI6Ik9DRiBDb2xsYWIgUk5BIn19.qZwQZ7ulazCHSUIkOCAi-ZJIF5rVLebTEVSz40Ya-Sqx8dcuJo81drMu5icHbIstm926cMIJFhA_b6DiCvoUhZgM8hWPmDNM9NnL3JiQ-DL_kYkBYJM85V3pQPVnAZWmWiO079VIfj6MR1mf14VeUIG1COxWl46-l9WooYE3fD70Um5Uv-g26n51RI_w0Ry5vQ-LYlFwhsEShlmXBMZTBoR6-8H6Sl6GkV36Dvtw3bSxRU8MvxFyG11Ot8pnEX_kZk05UJk1jTtMrWf1efqfbxeUPr4oHbpsmLHPZSUiIpfFMX9av_9eLVuK2qDXemC6Zwuf15lRmpJqk-x6kk6jRFi61VsObkvjsK77JZvkpQXlHpc8HxMUlBna6kEOjglgDVYM0c50txpIUH7F-11zLVMD_WOK3UoCtk_6hRAWXnXoWAwcG0RooHDXzW4JDEFTWuaTcat4vR3o5flyx0TQeTmzJ5UhmJZsWTvAoeNmed3pVdbqL4izmOfsxBD_7smuRD0EZ14LE81grw6enWwVltjjDxemkSop-XoQHUzJeJuF2xQlT_C-u1ehbH7pn_nTiU_6ld009s8bsmakQi625CUiX8npNumcB_o7Jq_TQ2CHXf2xNORXLxHVnPRrlLUMCIOVRDpLHntk8E_2zlPvtgzCbbC4bXU1elOwATnmtcw
```

You can preview its content using the debugger available on [JWT.io website](https://jwt.io/#debugger-io) by pasting the actual token part after the `Bearer` keyword.

### Token signature verification

Signature verification using `RS256` algorithm is required in order to ensure given token comes from OCF Collab network,

As the verification scheme is using RFC defined standards ([RFC 7519](https://tools.ietf.org/html/rfc7519), [RFC 7515](https://tools.ietf.org/html/rfc7515), [RFC 7517](https://tools.ietf.org/html/rfc7517)) you can find useful information in articles like [Navigating RS256 and JWKS](https://auth0.com/blog/navigating-rs256-and-jwks/).

For specific instructions regarding token verification refer the documentation of JWT library for your programming language. [List of available libraries](https://jwt.io/#libraries-io) is maintained on [JWT.io website](https://jwt.io/).

The JWK required for verifying the signature is available in JWKS set exposed via public endpoint which should be used on each verification (with optional caching). This way we can rotate the key without involvement on PNA side in case it gets compromised.

#### Signature details

##### Algorighm
RS256

##### JWKS endpoint
https://registry.ocf-collab.org/auth/keys

#### Ruby implementation example

```ruby
require "net/http"
require "jwt"

class OcfCollabJwtAuthenticator
  JWKS_URL = "https://registry.ocf-collab.org/auth/keys"
  ISSUER = "https://registry.ocf-collab.org"

  attr_reader :token

  def initialize(token:)
    @token = token
  end

  def token_payload
    @token_data ||= JWT.decode(
      token,
      nil,
      true,
      {
        jwks: jwks,
        iss: ISSUER,
        algorithm: :rs256, # Specify algorithm explicitly (https://auth0.com/blog/critical-vulnerabilities-in-json-web-token-libraries/)
        verify_expiration: true,
        verify_iss: true,
      },
    )[0]
  end

  private

  def jwks
    @jwks ||= JSON.parse(jwks_response).deep_symbolize_keys
  end

  def jwks_response
    @jwks_keys_response ||= Net::HTTP.get(URI.parse(JWKS_URL))
  end

  def header
    @header ||= JWT.decode(token, nil, false)[1]
  end
end

token = "eyJraWQiOiIxNDJlZjQwYzdjOGY2OTg5ZDNiNjBkMTc0ZDAyMGUzZGJmNGI5ZWI2NjViMGQ0YjBiOWQ0MjNjZGIyY2MwZDhlIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL3JlZ2lzdHJ5Lm9jZi1jb2xsYWIub3JnIiwiaWF0IjoxNjA2ODQ0MzY3LCJleHAiOjE2MDY4NDQ5NjcsImp0aSI6IjNjN2M3MDBmLWQ2NDctNGQ1My04NWY3LTc5ZWU1M2Y0YWM0NyIsInJuYSI6eyJpZCI6MSwibmFtZSI6Ik9DRiBDb2xsYWIgUk5BIn19.qZwQZ7ulazCHSUIkOCAi-ZJIF5rVLebTEVSz40Ya-Sqx8dcuJo81drMu5icHbIstm926cMIJFhA_b6DiCvoUhZgM8hWPmDNM9NnL3JiQ-DL_kYkBYJM85V3pQPVnAZWmWiO079VIfj6MR1mf14VeUIG1COxWl46-l9WooYE3fD70Um5Uv-g26n51RI_w0Ry5vQ-LYlFwhsEShlmXBMZTBoR6-8H6Sl6GkV36Dvtw3bSxRU8MvxFyG11Ot8pnEX_kZk05UJk1jTtMrWf1efqfbxeUPr4oHbpsmLHPZSUiIpfFMX9av_9eLVuK2qDXemC6Zwuf15lRmpJqk-x6kk6jRFi61VsObkvjsK77JZvkpQXlHpc8HxMUlBna6kEOjglgDVYM0c50txpIUH7F-11zLVMD_WOK3UoCtk_6hRAWXnXoWAwcG0RooHDXzW4JDEFTWuaTcat4vR3o5flyx0TQeTmzJ5UhmJZsWTvAoeNmed3pVdbqL4izmOfsxBD_7smuRD0EZ14LE81grw6enWwVltjjDxemkSop-XoQHUzJeJuF2xQlT_C-u1ehbH7pn_nTiU_6ld009s8bsmakQi625CUiX8npNumcB_o7Jq_TQ2CHXf2xNORXLxHVnPRrlLUMCIOVRDpLHntk8E_2zlPvtgzCbbC4bXU1elOwATnmtcw"
authenticator = OcfCollabJwtAuthenticator.new(token: token)

# Returns token payload if verification is successful.
# Raises JWT::DecodeError otherwise.
authenticator.token_payload
```

#### Sample token payload

```js
{
  "jti": "3c7c700f-d647-4d53-85f7-79ee53f4ac47",
  "iss": "https://registry.ocf-collab.org",
  "iat": 1606844367,
  "exp": 1606844967,
  "rna": {
    "id": 1,
    "name": "OCF Collab RNA"
  }
}
```

##### Token payload attributes

| Attribute | Description                                                                                       |
| --------- | ------------------------------------------------------------------------------------------------- |
| jti       | Unique identifier of given token.                                                                 |
| iss       | Issuer of the token. Should always be verified to be equal `https://registry.ocf-collab.org`.     |
| iat       | Time at which given token was issued.                                                             |
| exp       | Time at given token expires. Should always be verified to not be in the past.                     |
| rna.id    | ID of the Request Node Agent (RNA) as present in OCF Collab registry and transaction log.         |
| rna.name  | Name of the Request Node Agent (RNA) as present in OCF Collab registry and transaction log.       |


## Competency framework asset file endpoint

PNA is required to expose an endpoint authenticated with above describe method that returns the competency framework asset file based on ID matching one specified in Registry Entry file.

### Path

`/competency_frameworks/asset_file`

#### Parameters

| Parameter | Required | Type   | Description                                                         |
|-----------|----------|--------|---------------------------------------------------------------------|
| id        | Yes      | String | ID of specific framework as provided in Node Directory entry files. |

### Sample request

```
# GET https://pna-url.com/competency_frameworks/asset_file?id=https:%2F%2Fcredentialengineregistry.org%2Fgraph%2Fce-6f48f4bb-9d78-4947-8ab6-4722749f2733

{
  "@context": "https://credreg.net/ctdlasn/schema/context/json",
  "@id": "https://credentialengineregistry.org/graph/ce-6f48f4bb-9d78-4947-8ab6-4722749f2733",
  "@graph": [
    {
      "@id": "https://credentialengineregistry.org/resources/ce-6f48f4bb-9d78-4947-8ab6-4722749f2733",
      "@type": "ceasn:CompetencyFramework",
      "ceasn:name": {
[...]
