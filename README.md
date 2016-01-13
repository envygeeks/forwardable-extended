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

* `def_delegator :@hash, key, :bool => true|false|:reverse`
* `def_delegator :@hash, method, :key => :key, :bool => true|false|:reverse`
* `def_delegator :@ivar, method, :bool => true|false|:reverse`

Where if you send `:bool => true` then it will add "?" as a method suffix and
"!!" in front of the variable, and if you send `:bool => :reverse` it will also
add "?" as a method suffix and "!!!" in front of the variable.

### Example

```ruby
class Hello
  extend Forwardable::Extended

  def_delegator :@hash1, :hello1, :type => :hash
  def_delegator :@hash1, :world1, :key => :hello1, :type => :hash
  def_delegator :@hash1, :world1, :key => :hello1, :type => :hash, :bool => true
  def_delegator :@hash1, :not_world1, :key => :hello1, :type => :hash, :bool => :reverse
  def_delegator :@ivar1, :not_hello1, :type => :ivar, :bool => :reverse
  def_delegator :@ivar1, :hello1, :type => :ivar, :bool => true

  def initialize
    @ivar1 = :hello1
    @hash1 = {
      :hello1 => :world1
    }
  end
end

a = Hello.new
a.world1? # => true
a.hello1  # => world1
a.not_world1? # => false
a.not_hello1? # => false
a.world1  # => :world1
a.hello1? # => true
```
