require 'spec_helper'

describe LLT::Helpers::Constantize do
  class Dummy
    include LLT::Helpers::Constantize
  end

  module LLT
    class Test; end
    class TestSuffixed; end
    class PrefixedTest; end
    class PrefixedTestSuffixed; end
    class PrefixUsTestUs; end
  end

  class Test; end

  module TestModule
    class NestedTest; end
  end

  let(:dummy) { Dummy.new }

  describe "#constant_by_type" do
    it "returns a constant from a given type (as string)" do
      dummy.constant_by_type("test").should == LLT::Test
    end

    it "returns a constant from a given type (as symbol)" do
      dummy.constant_by_type(:test).should == LLT::Test
    end

    it "can be prefixed" do
      dummy.constant_by_type(:test, prefix: "prefixed").should == LLT::PrefixedTest
    end

    it "can be suffixed" do
      dummy.constant_by_type(:test, suffix: "suffixed").should == LLT::TestSuffixed
    end

    it "can be prefixed and suffixed" do
      dummy.constant_by_type(:test, prefix: "prefixed", suffix: "suffixed").should == LLT::PrefixedTestSuffixed
    end

    it "underscores are handled correctly - test_underscore to TestUnderscore" do
      dummy.constant_by_type(:test_us, prefix: :prefix_us).should == LLT::PrefixUsTestUs
    end

    it "namespace defaults to LLT" do
      dummy.constant_by_type("test").should == LLT::Test
    end

    it "namespace can be niled to access top level classes" do
      dummy.constant_by_type("test", namespace: nil).should == Test
    end

    it "accepts a namespace" do
      dummy.constant_by_type(:nested_test, namespace: TestModule).should == TestModule::NestedTest
    end

    it "defaults the type argument to @type when no type is given" do
      dummy.instance_variable_set("@type", :test)
      dummy.constant_by_type.should == LLT::Test
    end

    it "default at @type is returned in its :full form" do
      module LLT::Adjective; end
      module LLT::Adj; end

      dummy.instance_variable_set("@type", :adj)
      dummy.constant_by_type.should == LLT::Adjective
      dummy.constant_by_type.should_not == LLT::Adj
    end

    it "throws an error if type is nil" do
      expect { dummy.constant_by_type(prefix: :test) }.to raise_error
    end
  end
end
