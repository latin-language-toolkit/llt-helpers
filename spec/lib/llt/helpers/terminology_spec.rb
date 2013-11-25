require 'spec_helper'

describe LLT::Helpers::Terminology do
  let(:t) { LLT::Helpers::Terminology }

  describe "#key_term_for" do
    context "returns a normalized key for category names like tempus" do
      it "handles different words for inflection_class" do
        t.key_term_for(:inflectable_class).should == t.inflection_class
        t.key_term_for(:itype).should == t.inflection_class
        t.key_term_for(:inflection_class).should == t.inflection_class
      end

      it "handles different words for tempus" do
        t.key_term_for(:tense).should == t.tempus
        t.key_term_for(:tempus).should == t.tempus
      end

      it "handles different words for casus" do
        t.key_term_for(:casus).should == t.casus
        t.key_term_for(:case).should == t.casus
      end

      it "handles different words for modus" do
        t.key_term_for(:modus).should == t.modus
        t.key_term_for(:mood).should == t.modus
      end

      it "handles different words for modus" do
        t.key_term_for(:deponens).should == t.deponens
        t.key_term_for(:dep).should == t.deponens
      end

      it "normalizes strings to symbols" do
        t.key_term_for("tempus").should == t.tempus
      end
    end
  end

  describe "#value_term_for" do
    context "returns a normalized value - a key/category needs to given" do
      it "handles different tempus names" do
        t.value_term_for(:tempus, :pr).should == t.pr
        t.value_term_for(:tempus, :praesens).should == t.pr
        t.value_term_for(:tempus, :present).should == t.pr
      end

      it "normalizes strings to symbols" do
        t.value_term_for(:casus, "nominative").should == t.nom
      end

      it "normalizes pure digits strings to integers" do
        t.value_term_for(:inflection_class, '1').should == 1

        # edge case for this hacky solution
        t.value_term_for(:inflection_class, :esse).should == :esse
      end

      it "leaves alone Fixnums" do
        t.value_term_for(:casus, 2).should == t.gen
      end

      it "leaves alone booleans" do
        t.value_term_for(:deponens, true).should == true
        t.value_term_for(:deponens, false).should == false
      end

      it "tries to normalize the key when initial lookup fails" do
        t.value_term_for(:case, :acc).should == t.acc
      end
    end
  end

  describe "#values_for" do
    it "returns all valid values for a given key term" do
      t.values_for(:type).should include(:noun, :adjective, :adj)
    end

    it "key term is normalized" do
      t.values_for(:pos).should include(:noun, :adjective, :adj)
    end
  end

  describe "#norm_values_for" do
    it "returns all values for a key term, that are defined as getter methods - default format is used when not given" do
      t.norm_values_for(:numerus).should == [1, 2]
      t.norm_values_for(:numerus, format: :numeric).should == [1, 2]
      t.norm_values_for(:numerus, format: :abbr).should == [:sg, :pl]
      t.norm_values_for(:numerus, format: :full).should == [:singularis, :pluralis]
      t.norm_values_for(:numerus, format: :camelcase).should == [:Singularis, :Pluralis]

      t.norm_values_for(:persona).should == [1, 2, 3]
    end
  end

  describe ".method_missing" do
    it "returns the sent method name name" do
      t.whatever.should == :whatever
    end
  end

  context "contains methods that identify a given terminology standard" do
    it "returns a camelcases symbol if called with :camelcase" do
      t.pr(:camelcase).should == :Praesens
      t.fut_ex(:camelcase).should == :FuturumExactum

    end
    context "with tempora" do
      it "returns symbolic value in abbreviated form by default" do
        t.pr.should == :pr
      end

      it "returns symbolic value in unabbreviated latin with an argument of false" do
        t.pr(:full).should == :praesens
      end

      it "can return a numeric value" do
        t.pr(:numeric)    .should == 1
        t.impf(:numeric)  .should == 2
        t.fut(:numeric)   .should == 3
        t.pf(:numeric)    .should == 4
        t.pqpf(:numeric)  .should == 5
        t.fut_ex(:numeric).should == 6
      end
    end

    context "with casus and numerus" do
      it "returns numeric value of a casus by default" do
        t.genetivus.should == 2
        t.ablativus.should == 6
        t.singularis.should == 1
      end

      it "methods are aliased to an abbreviated form" do
        t.gen.should == 2
        t.dat.should == 3
        t.pl.should == 2
      end

      it "returns an abbreviated symbol with an argument of :abbr" do
        t.accusativus(:abbr).should == :acc
        t.pl(:abbr).should == :pl
      end

      it "returns an unabbreviated symbol with an argument of :full" do
        t.nom(:full).should == :nominativus
        t.pl(:full).should == :pluralis
      end
    end

    context "with sexus" do
      it "returns a one letter abbreviation by default" do
        t.m.should == :m
        t.f.should == :f
        t.n.should == :n
      end

      it "can return a numeric value" do
        t.m(:numeric).should == 1
        t.f(:numeric).should == 2
        t.n(:numeric).should == 3
      end
    end
  end
end
