[![Build Status](https://travis-ci.org/envygeeks/forwardable-extended.svg?branch=master)][travis]
[![Test Coverage](https://codeclimate.com/github/envygeeks/forwardable-extended/badges/coverage.svg)][coverage]
[![Code Climate](https://codeclimate.com/github/envygeeks/forwardable-extended/badges/gpa.svg)][codeclimate]
[![Dependency Status](https://gemnasium.com/envygeeks/forwardable-extended.svg)][gemnasium]

[gemnasium]: https://gemnasium.com/envygeeks/forwardable-extended
[codeclimate]: https://codeclimate.com/github/envygeeks/forwardable-extended
[coverage]: https://codeclimate.com/github/envygeeks/forwardable-extended/coverage
[travis]: https://travis-ci.org/envygeeks/forwardable-extended

# Forwardable Extended

Provides more `Forwardable` methods for your source as `Forwardable::Extended`.

## Current Methods

* `def_hash_delegator  hash, method, bool: true|false, revbool: true|false`
* `def_ivar_delegators [ivar, ivar], [method, method], bool: true|false, revbool: true|false`
* `def_hash_delegator  hash, method, key: hash_key, bool: true|false, revbool: true|false`
* `def_ivar_delegator  ivar, method, bool: true|false, revbool: true|false`

Where `bool` tell is to do "!!" and `revbool` tells it to do `!!!` and both tell it to make it a question method, so `def_hash_delegator :@hash, :key, bool: true` will create `key?` for you and it will return true or false on your behalf without you having to do it yourself.
