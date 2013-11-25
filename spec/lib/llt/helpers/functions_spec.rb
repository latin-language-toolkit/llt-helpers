require 'spec_helper'

describe LLT::Helpers::Functions do
  class Dummy
    include LLT::Helpers::Functions

    def functions
      [:a]
    end
  end

  let(:dummy) { Dummy.new }

  describe "#has_function?" do
    it "returns true if argument is included in #functions" do
      dummy.has_function?(:a).should be_true
    end

    it "returns false if argument is not included in #functions" do
      dummy.has_function?(:b).should be_false
    end
  end

  describe "#has_f?" do
    it "is a shortcut for #has_function?" do
      dummy.has_f?(:a).should be_true
      dummy.has_f?(:b).should be_false
    end
  end

  describe "#has_not_function?" do
    it "returns false if argument is included in #functions" do
      dummy.has_not_function?(:a).should be_false
    end

    it "returns true if argument is not included in #functions" do
      dummy.has_not_function?(:b).should be_true
    end
  end

  describe "#has_not_f?" do
    it "is a shortcut for #has_not_function?" do
      dummy.has_not_f?(:a).should be_false
      dummy.has_not_f?(:b).should be_true
    end
  end
end
