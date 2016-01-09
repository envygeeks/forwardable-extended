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
      def_hash_delegator :@hash1, :world1, key: :hello1
      def_ivar_delegator :@ivar1, :not_shouting1, revbool: true
      def_ivar_delegators [:@ivar2, :@ivar3], [:hello2, :hello3]
      def_ivar_delegator :@ivar1, :shouting1, bool: true
      def_hash_delegator :@hash1, :hello1

      def initialize
        @ivar1 = "hello1"
        @ivar2 = "hello2"
        @ivar3 = "hello3"
        @hash1 = {
          "hello1" => "world1"
        }
      end
    end
  end

  after :all do
    Object.send(:remove_const, :Hello)
  end

  #

  describe "#def_ivar_delegators" do
    it "should raise if the the arguments do not match" do
      expect { subject.class.send(:def_ivar_delegators, [:@ivar2, :@ivar3], [:ivar2]) }. \
        to raise_error ArgumentError
    end

    #

    context do
      it "should route keywords" do
        expect(subject.class).to receive(:def_ivar_delegator).twice.with(anything(), \
            anything(), bool: true) do

          nil
        end
      end

      after do
        subject.class.send(:def_ivar_delegators, [:@ivar2, :@ivar3], [:ivar2, :ivar3], \
          bool: true)
      end
    end
  end

  #

  specify { expect(subject. world1).to eq "world1" }
  specify { expect(subject.shouting1?).to eq true }
  specify { expect(subject. hello1).to eq "world1" }
  specify { expect(subject. hello2).to eq "hello2" }
  specify { expect(subject. hello3).to eq "hello3" }
  specify { expect(subject.not_shouting1?).not_to \
    eq(subject.shouting1?) }

  #

  it { is_expected.to respond_to :world1 }
  it { is_expected.to respond_to :not_shouting1? }
  it { is_expected.to respond_to :shouting1? }
  it { is_expected.to respond_to :hello1 }
  it { is_expected.to respond_to :hello2 }
  it { is_expected.to respond_to :hello3 }
end
