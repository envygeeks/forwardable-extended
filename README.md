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

```ruby
class MyClass
  rb_delegate :method_name, :to => :@ivar, :type => :ivar, :boolean => true
  rb_delegate :method_name, :to => :@ivar, :type => :ivar, :boolean => :reverse
  rb_delegate :method_name, :to => :hash, :type => :hash, :key => :the_key
  rb_delegate :method_name_is_key, :to => :hash, :type => :hash
end
```

* Any delegation can accept `alias_of` which will be the message sent to the object.
* You can send arguments by attaching the keyword `:args => [:my_arg]`, these are sent a `#to_s` message.
* Any delegation can be boolean if you wish it to be, even `:reverse`.
