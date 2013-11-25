require 'spec_helper'

describe LLT::Helpers::Configuration do
  class Dummy
    attr_reader :something
    include LLT::Helpers::Configuration
  end

  context "comes with an additional class method" do
    describe ".configuration" do
      it "provides a configuration hash" do
        Dummy.configuration.should be_a Hash
      end
    end

    describe ".uses_**" do
      it "is a method missing implementation" do
        expect { Dummy.uses_something { "test" } }.not_to raise_error
      end

      it "fills the classes configuration hash will procs" do
        pending
        Dummy.uses_something { "test" }
        conf = Dummy.configuration[:something]
        conf.should == "test"
      end

      it "reloads the configuration which might have changed in the meantime" do
        Dummy.uses_something { "test" }
        d1 = Dummy.new
        d1.configure
        Dummy.uses_something { "no_test" }
        d2 = Dummy.new
        d2.configure

        d1.something.should == "test"
        d2.something.should == "no_test"
      end

      it "stores the return value of the blk to avoid needless throw-away service objects" do
        Dummy.uses_something { "test" }
        d1 = Dummy.new
        d2 = Dummy.new
        d1.something.should be d2.something
      end
    end
  end

  let(:dummy) { Dummy.new }

  describe "#configure" do
    it "sets instance variables defined in the configuration hash" do
      Dummy.uses_something { "anything" }
      dummy.configure
      dummy.instance_variable_get("@something").should == "anything"
    end

    it "takes an options hash to overwrite the default configuration" do
      Dummy.uses_something { "anything" }
      dummy.configure(something: "nothing")
      dummy.instance_variable_get("@something").should == "nothing"
    end

    it "initializes only preconfiguraed variables and does nothing with other options" do
      Dummy.uses_something { "anything" }
      dummy.configure(another_thing: "thing")
      dummy.instance_variable_get("@something").should == "anything"
      dummy.instance_variable_get("@another_thing").should be_nil
    end
  end

  describe "#configuration" do
    it "returns the classes configuration" do
      dummy.configuration.should_not be_nil
    end
  end
end
