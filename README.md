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

* `def_delegator  :hash_object, key, :bool => true|false|:reverse, :type => :hash`
* `def_delegator  :hash_object, alias, :key => :hash_key, :bool => true|false|:reverse, :type => :hash`
* `def_delegator  :variable_object, method_name, :bool => true|false|:reverse, :type => :ivar`
* `def_delegators :object, :method, :method, :method, :args => [:your_optional_arg]`
* `def_delegator  :object, method, <optional:alias>, :args => [:your_arg]`

Where if you send `:bool => true` then it will add "?" as a method suffix and
"!!" in front of the variable, and if you send `:bool => :reverse` it will also
add "?" as a method suffix and "!!!" in front of the variable.

If you send `:args => []` on a normal delegation we add your args to the front
of the method any user args are concactinated by `ruby` through `*args`.  This makes
it so you can do fancy things like:

```ruby
require "forwardable/extended"

class MyPathname
  extend Forwardable::Extended
  def_delegator :File, :join, {
    :args => [
      :@path, %{"str_too"}
    ]
  }

  def initialize(path)
    @path = path
  end
end

MyPathname.new("/tmp").join("world") # => "/tmp/str_too/world"
```
