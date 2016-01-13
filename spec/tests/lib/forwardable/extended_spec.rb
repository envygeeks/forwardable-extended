# Frozen-string-literal: true
# Copyright: 2015-2016 Jordon Bedwell - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Forwardable::Extended do
  let(:subject1) { Hello1.new }
  let(:subject2) { Hello2.new }

  #

  before :all do
    class Hello1
      extend Forwardable::Extended

      def_delegator :@hash1, :hello1, :type => :hash
      def_delegator :@hash1, :world1, :key => :hello1, :type => :hash
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

    class Hello2
      extend Forwardable::Extended
      def_delegator :@class, :test1, {
        :args => %{"routed"}
      }

      def initialize
        @class = Hello1.new
      end
    end
  end

  after :all do
    Object.send(:remove_const, :Hello1)
    Object.send(:remove_const, :Hello2)
  end

  specify { expect(subject1).to respond_to :hello1  }
  specify { expect(subject1).to respond_to :world1  }
  specify { expect(subject1).to respond_to :not_world1? }
  specify { expect(subject1).to respond_to :not_hello1? }
  specify { expect(subject1).to respond_to :world1? }
  specify { expect(subject1).to respond_to :hello1? }
  specify { expect(subject1).to respond_to :to_s }

  specify { expect(subject1.world1?).to eq true }
  specify { expect(subject1.hello1 ).to eq :world1 }
  specify { expect(subject1.not_world1?).to eq false }
  specify { expect(subject1.not_hello1?).to eq false }
  specify { expect(subject1.world1 ).to eq :world1 }
  specify { expect(subject1.hello1?).to eq true }
  specify { expect(subject1.test2(:it, :works)).to eq "world it works" }
  specify { expect(subject2.test1(:hello, :world)).to eq "routed hello world"}
  specify { expect(subject1.to_s).to eq "hello2" }
end
