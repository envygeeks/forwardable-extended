# Frozen-string-literal: true
# Copyright: 2015-2016 Jordon Bedwell - MIT License
# Encoding: utf-8

require "forwardable/extended/version"
require "forwardable"

module Forwardable
  module Extended
    include Forwardable

    def def_hash_delegator(hash, *methods, key: nil, bool: false, revbool: false)
      line = __LINE__ - 1
      file = __FILE__

      [methods].flatten.each do |method|
        prefix = bool || revbool ? "!!#{"!" if revbool}" : ""
        var = key ? %(#{hash}["#{key}"]) : %(#{hash}["#{method}"])
        method = method.to_s + "?" if revbool || bool

        ruby = <<-STR
          def #{method}
            #{prefix}#{var}
          end
        STR

        class_eval ruby, file, line
      end
    end

    def def_ivar_delegator(var, method, bool: false, revbool: false)
      line = __LINE__ - 1
      file = __FILE__

      prefix = revbool || bool ? "!!#{"!" if revbool}" : ""
      method = method.to_s + "?" if revbool || bool
      ruby = <<-STR
        def #{method}
          #{prefix}#{var}
        end
      STR

      class_eval ruby, file, line
    end

    def def_ivar_delegators(vars, methods, **kwd)
      raise ArgumentError, "unequal methods and vars" unless vars.size == methods.size
      methods.zip(vars).each do |method, var|
        def_ivar_delegator var, method, **kwd
      end
    end
  end
end
