require 'spec_helper'

describe LLT::Helpers::Transformer do
  class Dummy
    include LLT::Helpers::Transformer

    def initialize
      @a = 1
      @b = 2
      @c = 3
    end
  end

  let(:dummy) { Dummy.new }

  describe "#to_hash" do
    it "maps all instance variables to key/value pairs" do
      dummy.to_hash.should == { a: 1, b: 2, c: 3 }
    end

    it "root node can be given" do
      dummy.to_hash(root: "a_root").should == { "a_root" => { a: 1, b: 2, c: 3 } }
    end

    it "if root node is given as instance of TrueClass, the class name gets used as root node" do
      dummy.to_hash(root: true).should == { "Dummy" =>  { a: 1, b: 2, c: 3 } }
    end

    it "if symbols are given in a whitelist, only corresponding values will get returned" do
      dummy.to_hash(whitelist: [:a, :b]).should == { a: 1, b: 2 }
    end

    it "if symbols are given in a blacklist, these values will be skipped" do
      dummy.to_hash(blacklist: [:b]).should == { a: 1, c: 3 }
    end

    it "default type for keys are symbols, can be manipulated with keys: #method" do
      dummy.to_hash(whitelist: [:a], keys: :to_s).should == { "a" => 1 }
    end

    it "custom contents can be given" do
      dummy.to_hash(custom: { a: 5 }, whitelist: [:b]).should == { a: 5, b: 2 }
    end

    it "custom contents would still be inside a root node" do
      dummy.to_hash(custom: { a: 5 }, blacklist: [:b, :c], root: :root).should == { root: { a: 5 } }
    end
  end
end
