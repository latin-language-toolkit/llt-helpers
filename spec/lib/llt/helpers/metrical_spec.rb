require 'spec_helper'

describe LLT::Helpers::Metrical do
  class Dummy
    include LLT::Helpers::Metrical
  end

  let(:dummy) { Dummy.new }

  describe "#evaluate_metrical_presence" do
    it "evaluates if a given string contains metrical utf8 information" do
      dummy.evaluate_metrical_presence("test").should be_false
      dummy.evaluate_metrical_presence("tēst").should be_true
    end

    it "returns false if the given string is actually nil" do
      dummy.evaluate_metrical_presence(nil).should be_false
    end
  end

  describe "#metrical?" do
    it "defaults to false" do
      dummy.metrical?.should be_false
    end

    it "responds accordingly after successful evaluation" do
      dummy.evaluate_metrical_presence("test")
      dummy.metrical?.should be_false

      dummy.evaluate_metrical_presence("tēst")
      dummy.metrical?.should be_true
    end
  end

  describe "#wo_meter" do
    it "strips all quantifying diacritics of a string" do
      dummy.wo_meter('fēmĭnīs').should == 'feminis'
    end
  end
end
