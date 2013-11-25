require 'spec_helper'

describe LLT::Helpers::QueryMethods do
  class Test
    extend LLT::Helpers::QueryMethods

    def initialize(type = nil)
      @type = type
      @other_type = :noun
    end
  end



  describe ".add_query_methods_for" do

    context "without optional arguments" do
      it "adds all available query methods deriving from values for a key term as defined in LLT::Constants::Terminology" do
        Test.add_query_methods_for(:type)
        t = Test.new
        t.should respond_to :noun?
        t.should respond_to :adj?
        t.should respond_to :adjective?
      end

      it "checks equality of a normalized value, stashed in an inst var named like the key term" do
        Test.add_query_methods_for(:type)
        t = Test.new(:adjective)
        t.adj?.should be_true
        t.adjective?.should be_true
        t.noun?.should be_false
      end
    end

    context "with option :use" do
      it "redirects to another inst var" do
        Test.add_query_methods_for(:type, use: :@other_type)
        t = Test.new(:adj)
        t.adj?.should be_false
        t.noun?.should be_true
      end
    end

    context "with option :delegate_to" do
      it "delegates the equality check to the given method or variable" do
        class Dummy
          def noun?; true;  end
          def adj?; false; end
        end
        Test.add_query_methods_for(:type, delegate_to: :@type)
        t = Test.new(Dummy.new)
        t.adj?.should be_false
        t.noun?.should be_true
      end
    end

    context "with options :use and :delegate_to" do
      it "raises an error" do
        expect { Test.add_query_methods_for(:type, use: :x, delegate_to: :y) }.to raise_error(ArgumentError)
      end
    end

    context "with a lambda" do
      it "uses the block to handle the query"
    end
  end
end
