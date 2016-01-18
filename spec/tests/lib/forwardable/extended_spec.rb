# Frozen-string-literal: true
# Copyright: 2015-2016 Jordon Bedwell - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Forwardable::Extended do
  let(:subject1) { Hello1.new }
  let(:subject2) { Hello2.new }
  let(:subject3) { Hello3.new }

  #

  before :all do
    class Hello1
      extend Forwardable::Extended

      def_delegator :@hash1, :hello1, :type => :hash
      def_delegator :@hash1, :world1, :key => :hello1, :type => :hash
      def_delegator :@ivar1, :to_s, :wrap_test, :wrap => :"Pathname.new"
      def_delegator :@hash1, :world1, :key => :hello1, :type => :hash, :bool => true
      def_delegator :@hash1, :not_world1, :key => :hello1, :type => :hash, :bool => :reverse
      def_delegator :@ivar1, :not_hello1, :type => :ivar, :bool => :reverse
      def_delegator :@ivar1, :hello1, :type => :ivar, :bool => true
      def_delegator :self, :test1, :test2, :args => %{"world"}
      def_delegator :@ivar2, :to_s

      def initialize
        @ivar1 = :hello1
        @ivar2 = :hello2
        @hash1 = {
          :hello1 => :world1
        }
      end

      def test1(*args)
        args.join(
          " "
        )
      end
    end

    #

    class Hello2
      extend Forwardable::Extended
      def_delegators :File, :basename, :dirname, :args => %q{"/tmp/hello"}
      def_delegator  :@class, :test1, :args => %{"routed"}

      def initialize
        @class = Hello1.new
      end
    end

    #

    class Hello3
      extend Forwardable::Extended
      rb_delegate :hello1, :to => :@hash1, :type => :hash
      rb_delegate :world1, :to => :@hash1, :key => :hello1, :type => :hash
      rb_delegate :test2, :to => :self, :args => %{"world"}, :alias_of => :test1
      rb_delegate :wrap_test, :to => :@ivar1, :alias_of => :to_s, :wrap => :"Pathname.new"
      rb_delegate :world1, :to => :@hash1, :key => :hello1, :type => :hash, :bool => true
      rb_delegate :not_world1?, :to => :@hash1, :key => :hello1, :type => :hash, :bool => :reverse
      rb_delegate :not_hello1, :to => :@ivar1, :type => :ivar, :bool => :reverse
      rb_delegate :hello1, :to => :@ivar1, :type => :ivar, :bool => true
      rb_delegate :to_s, :to => :@ivar2

      def initialize
        @ivar1 = :hello1
        @ivar2 = :hello2
        @hash1 = {
          :hello1 => :world1
        }
      end

      def test1(*args)
        args.join(
          " "
        )
      end

    end
  end

  #

  after :all do
    Object.send(:remove_const, :Hello1)
    Object.send(:remove_const, :Hello2)
    Object.send(:remove_const, :Hello3)
  end

  #

  specify do
    expect(subject1).to respond_to(
      :hello1
    )
  end

  #

  specify do
    expect(subject1).to respond_to(
      :world1
    )
  end

  #

  specify do
    expect(subject1).to respond_to(
      :not_world1
    )
  end

  #

  specify do
    expect(subject1).to respond_to(
      :not_hello1
    )
  end

  #

  specify do
    expect(subject1).to respond_to(
      :world1
    )
  end

  #

  specify do
    expect(subject1).to respond_to(
      :hello1
    )
  end

  #

  specify do
    expect(subject1).to respond_to(
      :to_
    )
  end

  #

  specify do
    expect(subject1.world1?).to eq(
      true
    )
  end

  #

  specify do
    expect(subject1.hello1 ).to eq(
      :world1
    )
  end

  #

  specify do
    expect(subject1.not_world1?).to eq(
      false
    )
  end

  #

  specify do
    expect(subject1.test2(:it, :works)).to eq(
      "world it works"
    )
  end

  #

  specify do
    expect(subject1.wrap_test).to eq(
      Pathname.new("hello1")
    )
  end

  #

  specify do
    expect(subject1.not_hello1?).to eq(
      false
    )
  end

  #

  specify do
    expect(subject1.world1 ).to eq(
      :world1
    )
  end

  #

  specify do
    expect(subject1.hello1?).to eq(
      true
    )
  end

  #

  specify do
    expect(subject1.to_s).to eq(
      "hello2"
    )
  end

  #

  specify do
    expect(subject2.basename).to eq(
      "hello"
    )
  end

  #

  specify do
    expect(subject2.test1(:hello, :world)).to eq(
      "routed hello world"
    )
  end

  #

  specify do
    expect(subject2.dirname).to eq(
      "/tmp"
    )
  end

  #

  specify do
    expect(subject3).to respond_to(
      :hello1
    )
  end

  #

  specify do
    expect(subject3).to respond_to(
      :world1
    )
  end

  #

  specify do
    expect(subject3).to respond_to(
      :not_world1
    )
  end

  #

  specify do
    expect(subject3).to respond_to(
      :not_hello1
    )
  end

  #

  specify do
    expect(subject3).to respond_to(
      :world1
    )
  end

  #

  specify do
    expect(subject3).to respond_to(
      :hello1
    )
  end

  #

  specify do
    expect(subject3).to respond_to(
      :to_
    )
  end

  #

  specify do
    expect(subject3.world1?).to eq(
      true
    )
  end

  #

  specify do
    expect(subject3.hello1 ).to eq(
      :world1
    )
  end

  #

  specify do
    expect(subject3.not_world1?).to eq(
      false
    )
  end

  #

  specify do
    expect(subject3.test2(:it, :works)).to eq(
      "world it works"
    )
  end

  #

  specify do
    expect(subject3.wrap_test).to eq(
      Pathname.new("hello1")
    )
  end

  #

  specify do
    expect(subject3.not_hello1?).to eq(
      false
    )
  end

  #

  specify do
    expect(subject3.world1 ).to eq(
      :world1
    )
  end

  #

  specify do
    expect(subject3.hello1?).to eq(
      true
    )
  end

  #

  specify do
    expect(subject3.to_s).to eq(
      "hello2"
    )
  end
end
