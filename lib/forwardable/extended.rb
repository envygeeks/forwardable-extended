# Frozen-string-literal: true
# Copyright: 2015-2016 Jordon Bedwell - MIT License
# Encoding: utf-8

require "forwardable/extended/version"
require "forwardable"

module Forwardable
  module Extended
    DEF_DELEGATOR = Object::Forwardable.instance_method(:def_delegator)
    def def_hash_delegator(hash, method, key: method, bool: false, args: nil, \
          user_args: nil, type: :ivar)

      prefix = (bool == :reverse ? "!!!" : "!!") if bool
      suffix = (bool ? "?" : "")

      class_eval <<-STR, __FILE__, __LINE__
        def #{method}#{suffix}
          #{prefix}#{hash}[#{key.inspect}]
        end
      STR
    end

    #

    def def_ivar_delegator(ivar, alias_ = ivar, bool: false, args: nil, \
          user_args: nil, type: :ivar)

      prefix = (bool == :reverse ? "!!!" : "!!") if bool
      suffix = (bool ? "?" : "")

      class_eval <<-STR, __FILE__, __LINE__
        def #{alias_.to_s.gsub(/\A@/, "")}#{suffix}
          #{prefix}#{ivar}
        end
      STR
    end

    #

    def def_delegator(accessor, method, *args)
      if args.empty? || args.size > 1 || !args.first.is_a?(Hash)
        return DEF_DELEGATOR.bind(self).call(
          accessor, method, *args
        )
      end

      if args.first[:type]
        return send("def_#{args.first[:type]}_delegator",
          accessor, method, *args)
      end

      prefix = (kwd[:bool] == :reverse ? "!!!" : "!!") if kwd[:bool]
      suffix = (kwd[:bool] ? "?" : "")

      class_eval <<-STR, __FILE__, __LINE__
        def #{method}#{suffix}
          #{prefix}#{accessor}.send(#{alias_.inspect})
        end
      STR
    end
  end
end
