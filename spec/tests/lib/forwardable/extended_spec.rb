# Frozen-string-literal: true
# Copyright: 2015-2016 Jordon Bedwell - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Forwardable::Extended do
  subject do
    Hello.new
  end

  #

  before :all do
    class Hello
      extend Forwardable::Extended

      def_delegator :@hash1, :hello1, :type => :hash
      def_delegator :@hash1, :world1, :key => :hello1, :type => :hash
      def_delegator :@hash1, :world1, :key => :hello1, :type => :hash, :bool => true
      def_delegator :@hash1, :not_world1, :key => :hello1, :type => :hash, :bool => :reverse
      def_delegator :@ivar1, :not_hello1, :type => :ivar, :bool => :reverse
      def_delegator :@ivar1, :hello1, :type => :ivar, :bool => true
      def_delegator :@ivar1, :to_s, :ivar_to_s

      def initialize
        @ivar1 = :hello1
        @hash1 = {
          :hello1 => :world1
        }
      end
    end
  end

  after :all do
    Object.send(:remove_const, :Hello)
  end

  it { is_expected.to respond_to :hello1  }
  it { is_expected.to respond_to :world1  }
  it { is_expected.to respond_to :not_world1? }
  it { is_expected.to respond_to :not_hello1? }
  it { is_expected.to respond_to :ivar_to_s }
  it { is_expected.to respond_to :world1? }
  it { is_expected.to respond_to :hello1? }

  specify { expect(subject.world1?).to eq true }
  specify { expect(subject.hello1 ).to eq :world1 }
  specify { expect(subject.not_world1?).to eq false }
  specify { expect(subject.ivar_to_s).to eq "hello1" }
  specify { expect(subject.not_hello1?).to eq false }
  specify { expect(subject.world1 ).to eq :world1 }
  specify { expect(subject.hello1?).to eq true }
end
