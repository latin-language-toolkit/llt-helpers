require 'spec_helper'

describe LLT::Helpers::Normalizer do
  describe "#normalize_args" do
    def norm(args)
      normalizer.normalize_args(args)
    end

    let(:normalizer) { LLT::Helpers::Normalizer }
    let(:dummy) { Dummy.new }

    it "can be included as instance method" do
      class Dummy
        include LLT::Helpers::Normalizer
      end


      dummy.should respond_to(:normalize_args)
    end

    it "can be called as module method" do
      normalizer.should respond_to(:normalize_args)
    end

    describe "rebuilds an argument hash with LLT::Constants::Terminology" do
      it "normalizes" do
        args = { "tense" => "present", case: "acc", numerus: "singular" }
        norm(args).should == { tempus: :pr, casus: 4, numerus: 1 }
      end

      it "additionally normalizes the key stem to a symbol, even if there is no key term for it" do
        args = { 'type' => 'noun', 'stem' => 'exercit', 'iclass' => '4', 'gender' => 'm' }
        norm(args).should == { type: :noun, stem: 'exercit', inflection_class: 4, sexus: :m }
      end
    end

    it "normalizes a nested options hash as well" do
      args = { tempus: :present, options: { mood: :indicative } }
      norm(args).should == { tempus: :pr, options: { modus: :ind  } }
    end

    it "normalizes a nested options hash as well II" do
      args = { options: { mood: "gerund" } }
      norm(args).should == { options: { modus: :gerundium } }
    end

    it "leaves unknown keys intact" do
      args = { "foo" => "bar" }
      norm(args).should == args
    end

    it "leaves pure string values intact (nominative and stem)" do
      norm(nom: "libido").should == { nom: "libido" }
      norm(nominative: "libido").should == { nom: "libido" }
    end
  end
end
