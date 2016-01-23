# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2015-2016 Jordon Bedwell - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "forwardable/extended/version"
require "forwardable"

module Forwardable
  module Extended

    # ------------------------------------------------------------------------
    # Make our methods private on the class, there is no reason for public.
    # ------------------------------------------------------------------------

    def self.extended(klass)
      instance_methods.each do |method|
        klass.private_class_method(
          method
        )
      end
    end

    # ------------------------------------------------------------------------
    # A simpler delegator that wraps around `def_delegator` and makes it easy.
    # ------------------------------------------------------------------------

    def rb_delegate(method, to: nil, alias_of: method, **kwd)
      raise ArgumentError, "to must be provided" unless to
      def_delegator(
        to, alias_of, method, **kwd
      )
    end

    # ------------------------------------------------------------------------
    # Delegates a method to a `hash[key]`.
    # @param [Symbol] key used if method is an alias; disignates the hash key.
    # @param [Hash] hash the hash object you wish to delegate to.
    # ------------------------------------------------------------------------

    def def_hash_delegator(hash, method, key: method, **kwd)
      prefix, suffix, wrap = __prepare(**kwd)

      if suffix
        method = method.to_s.gsub(
          /\?$/, ""
        )
      end

      class_eval <<-STR, __FILE__, __LINE__ - 3
        def #{method}#{suffix}(*args)
          #{wrap}(
            #{prefix}#{hash}[#{key.inspect}]
          )

        rescue Exception
          unless Forwardable.debug
            $@.delete_if do |source|
              source =~ %r"#{Regexp.escape(__FILE__)}"o
            end
          end

          raise
        end
      STR
    end

    # ------------------------------------------------------------------------
    # Delegates a method to an instance variable.
    # @note if you are not using an alias or booleans use `attr_reader`.
    # @param [String, Symbol] ivar the instance variable.
    # @param [String, Symbol] alias_ the alias.
    # ------------------------------------------------------------------------

    def def_ivar_delegator(ivar, alias_ = ivar, **kwd)
      prefix, suffix, wrap = __prepare(**kwd)

      if suffix
        alias_ = alias_.to_s.gsub(
          /\?$/, ""
        )
      end

      class_eval <<-STR, __FILE__, __LINE__ - 3
        def #{alias_.to_s.gsub(/\A@/, "")}#{suffix}
          #{wrap}(
            #{prefix}#{ivar}
          )

        rescue Exception
          unless Forwardable.debug
            $@.delete_if do |source|
              source =~ %r"#{Regexp.escape(__FILE__)}"o
            end
          end

          raise
        end
      STR
    end

    # ------------------------------------------------------------------------
    # A more beefed up version of Ruby's `def_delegator` that
    # offers a tiny bit more than the default version in `Forwardable`
    # @param [Object<>] accessor the object to ship your method to.
    # @param [String, Symbol] method the method being messaged.
    # @param [Array<>] args the arguments to place in front.
    # ------------------------------------------------------------------------

    def def_modern_delegator(accessor, method, alias_ = method, args: [], **kwd)
      args = [args].flatten.compact.map(&:to_s).unshift("").join(", ")
      prefix, suffix, wrap = __prepare(**kwd)

      if suffix
        alias_ = alias_.to_s.gsub(
          /\?$/, ""
        )
      end

      class_eval <<-STR, __FILE__, __LINE__ - 4
        def #{alias_}#{suffix}(*args, &block)
          #{wrap}(#{prefix}#{accessor}.send(
            #{method.inspect}#{args}, *args, &block
          ))

        rescue Exception
          unless Forwardable.debug
            $@.delete_if do |source|
              source =~ %r"#{Regexp.escape(__FILE__)}"o
            end
          end

          raise
        end
      STR
    end

    # ------------------------------------------------------------------------
    # Wraps around traditional def_delegator to offer forwarding to modern,
    # ivar and hash delegators.  With a bit of data checking between.
    # @see `Object::Forwardable#def_delegator`
    # ------------------------------------------------------------------------

    def def_delegator(accessor, method, alias_ = method, **kwd)
      kwd, alias_ = alias_, method if alias_.is_a?(Hash) && !kwd.any?

      if alias_.is_a?(Hash) || !kwd.any?
        Forwardable.instance_method(:def_delegator).bind(self) \
          .call(accessor, method, alias_)

      elsif !kwd[:type]
        def_modern_delegator(
          accessor, method, alias_, **kwd
        )

      else
        raise ArgumentError, "Alias not supported with type" if alias_ != method
        send("def_#{kwd[:type]}_delegator", accessor, method, **kwd.tap { |obj|
          obj.delete(:type)
        })
      end
    end

    # ------------------------------------------------------------------------
    # Wraps around traditional `def_delegators` to detect hash arguments.
    # @see `Object::Forwardable#def_delegators`
    # ------------------------------------------------------------------------

    def def_delegators(accessor, *methods)
      kwd = methods.shift if methods.first.is_a?(Hash)
      kwd = methods.pop   if methods. last.is_a?(Hash)
      kwd = {} unless kwd

      methods.each do |method|
        def_delegator accessor, method, **kwd
      end
    end

    # ------------------------------------------------------------------------
    # Prepares the suffix, prefix and wrap method if available.
    # @param [true, false, :reverse] bool whether or not this is a boolean.
    # @param [true, Symbol, String] wrap wrap result into the wrap.
    # ------------------------------------------------------------------------

    private
    def __prepare(wrap: nil, bool: false)
      prefix = (bool == :reverse ? "!!!" : "!!") if bool
      wrap   = "self.class.new" if wrap.is_a?(TrueClass)
      suffix = "?" if bool

      return [
        prefix, suffix, wrap
      ]
    end
  end
end
