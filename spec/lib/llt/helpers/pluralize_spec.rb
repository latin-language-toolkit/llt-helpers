require 'spec_helper'

describe LLT::Helpers::Pluralize do
  class Dummy
    include LLT::Helpers::Pluralize
  end

  let(:dummy) { Dummy.new }

  describe "#pluralize" do
    describe "pluralizes like rails" do
      context "when count is 1" do
        it "returns sg" do
          dummy.pluralize(1, "form").should == "form"
        end
      end

      context "when count is 0 or < 1" do
        context "without pl as param" do
          it "builds s" do
            dummy.pluralize(0, "form").should == "forms"
            dummy.pluralize(2, "form").should == "forms"
          end

          it "builds y to ies" do
            dummy.pluralize(2, "entry").should == "entries"
          end
        end

        context "with custom pl as param" do
          it "uses the custom plural" do
            dummy.pluralize(2, "sg", "whatever").should == "whatever"
          end
        end
      end
    end
  end
end
