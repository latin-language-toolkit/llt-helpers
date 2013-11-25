require 'spec_helper'

describe LLT::Helpers::Equality do
  class Dummy2
    extend LLT::Helpers::Equality

    attr_reader :type, :lemma_key, :tempus

    def initialize(type, lemma_key, tempus)
      @type = type
      @lemma_key = lemma_key
      @tempus = tempus
    end
  end

  describe ".equality_of_***_defined_by" do
    it "defines attributes through which equality is identified and adds a method to ask for it" do
      Dummy2.equality_of_lemma_defined_by :type, :lemma_key
      d = Dummy2.new(:verb, 1489, :perfectum)
      d.should respond_to(:equality_definition_for_lemma)
      d.should respond_to(:same_lemma_as?)
    end
  end

  describe "#same_***_as?" do
    it "checks for equality as defined in the class definition" do
      Dummy2.equality_of_lemma_defined_by :type, :lemma_key
      d1 = Dummy2.new(:verb, 1, :perfectum)
      d2 = Dummy2.new(:verb, 1, :futurum)
      d3 = Dummy2.new(:verb, 2, :perfectum)

      d1.same_lemma_as?(d2).should be_true
      d1.same_lemma_as?(d3).should be_false
    end

    it "works through method missing" do
      Dummy2.equality_of_form_defined_by :type, :lemma_key, :tempus
      d1 = Dummy2.new(:verb, 1, :perfectum)
      d2 = Dummy2.new(:verb, 1, :futurum)
      d3 = Dummy2.new(:verb, 2, :perfectum)
      d4 = Dummy2.new(:verb, 1, :perfectum)

      d1.same_form_as?(d2).should be_false
      d1.same_form_as?(d3).should be_false
      d1.same_form_as?(d4).should be_true
    end
  end
end
