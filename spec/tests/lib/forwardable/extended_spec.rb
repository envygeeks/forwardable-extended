# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2015-2016 Jordon Bedwell - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "rspec/helper"
describe Forwardable::Extended do
  class ForwardableExtendedTestClass1
    extend Forwardable::Extended
    Forwardable::Extended.instance_methods.map do |m|
      rb_delegate m, :to => :"self.class"
    end

    #

    def wrap_test(val)
      return {
        :wrapped => val
      }
    end
  end

  #

  subject do
    (ForwardableExtendedTestClass1.dup).new
  end

  #

  describe "#def_hash_delegator" do
    before do
      subject.instance_variable_set(:@test, {
        :key => :val
      })
    end

    #

    context "when not given a key" do
      it "should infer the key from the method" do
        subject.def_hash_delegator :@test, :key
        expect(subject.key).to eq(
          :val
        )
      end
    end

    #

    context "when given a key via :key => key" do
      it "should use that key" do
        subject.def_hash_delegator :@test, :hello, :key => :key
        expect(subject.hello).to eq(
          :val
        )
      end
    end

    #

    context "when creating booleans" do
      context "when given a method name without ?" do
        it "should add the ?" do
          subject.def_hash_delegator :@test, :key, :bool => true
          expect(subject).to respond_to(
            :key?
          )
        end
      end

        #

      context "when given a method name with ?" do
        it "should keep it" do
          subject.def_hash_delegator :@test, :key?, :bool => true, :key => :key
          expect(subject).to respond_to(
            :key?
          )
        end
      end

      #

      it "supports reverse booleans" do
        subject.def_hash_delegator :@test, :key, :bool => :reverse
        expect(subject.key?).to eq(
          false
        )
      end

      #

      it "supports truthy booleans" do
        subject.def_hash_delegator :@test, :key, :bool => true
        expect(subject.key?).to eq(
          true
        )
      end

      #

      context "wrapping" do
        it "allows the user to wrap the result in another method or class" do
          subject.def_hash_delegator :@test, :key, :wrap => :wrap_test
          expect(subject.key).to eq({
            :wrapped => :val
          })
        end
      end
    end
  end

  #

  describe "#def_ivar_delegator" do
    before do
      subject.instance_variable_set(:@test, {
        :key => :val
      })
    end

    #

    context "when creating booleans" do
      context "when given a method name without ?" do
        it "should add the ?" do
          subject.def_ivar_delegator :@test, :bool => true
          expect(subject).to respond_to(
            :test?
          )
        end
      end

      #

      context "when given a method name with ?" do
        it "should keep it" do
          subject.def_ivar_delegator :@test, :test?, :bool => true
          expect(subject).to respond_to(
            :test?
          )
        end
      end

      #

      it "supports reverse booleans" do
        subject.def_ivar_delegator :@test, :bool => :reverse
        expect(subject.test?).to eq(
          false
        )
      end

      #

      it "supports truthy booleans" do
        subject.def_ivar_delegator :@test, :bool => true
        expect(subject.test?).to eq(
          true
        )
      end
    end
  end

  #

  describe "#def_modern_delegator" do
    before :all do
      class ForwardableExtendedTestClass2
        def self.test(*args)
          if args.empty?
            :val

          else
            args
          end
        end
      end
    end

    #

    it "can delegate to anotehr method" do
      subject.def_modern_delegator :ForwardableExtendedTestClass2, :test
      expect(subject.test).to eq(
        :val
      )
    end

    #

    it "can alias a delegate" do
      subject.def_modern_delegator :ForwardableExtendedTestClass2, :test, :hello
      expect(subject).to respond_to(
        :hello
      )
    end

    #

    context "passing args" do
      it "should support passing args before user args" do
        subject.def_modern_delegator :ForwardableExtendedTestClass2, :test, :args => %{"before"}
        expect(subject.test("world")).to eq [
          "before", "world"
        ]
      end

      #

      it "should support passing args before and after user args" do
        subject.def_modern_delegator :ForwardableExtendedTestClass2, :test, \
          :args => { :before => %{"before"}, :after => %{"after"}}

        expect(subject.test("world")).to eq [
          "before", "world", "after"
        ]
      end

      #

      it "should support passing args after user args" do
        subject.def_modern_delegator :ForwardableExtendedTestClass2, :test, \
          :args => { :after => %{"after"}}

        expect(subject.test("world")).to eq [
          "world", "after"
        ]
      end
    end
  end
end
