# Changelog

## 1.6.1

* Make key symbolisation safer

## 1.6.0

* Added support for RS256 signing algorithm (thanks to [Catalin Voineag](https://github.com/CatalinVoineag))

## v1.5.0

* Added support for JWT headers

## v1.4.0

* Transferred to OPSS GitHub; gem is no longer published to Rubygems

## v1.3.0

* Added support for multi-domain apps - use a relative URI for the `redirect_uri` and the requesting domain will be automatically used (note that all valid redirect URIs will need to be added to GOV.UK One Login for this to work)

## v1.2.0

* Added support for backchannel logout token verification

## v1.1.2

* Tweaked logout utility to use `id_token`

## v1.1.1

* Added metadata to gemspec
* Enabled Dependabot
* Enabled rubocop

## v.1.1.0

* Added support for PKCE

## v1.0.1

* Added changelog

## v1.0.0

Initial version.
