require 'spec_helper'

describe LLT::Helpers::RomanNumerals do
  describe ".roman?" do
    it "detects if given value is a roman numeral" do
      subject.roman?("MDCIX").should be_true
    end

    it "recognizes only fully upcased values as numeral atm" do
      subject.roman?("mdcix").should be_false
    end

    it "doesn't match potentially misleading strings like M. for Marcus" do
      subject.roman?("M.").should be_false
    end
  end

  describe ".to_roman" do
    LLT::Constants::NUMERALS.each do |dec, rom|
      it "converts #{dec} to #{rom}" do
        subject.to_roman(dec).should == rom
      end
    end

    it "converts 1984 to MCMLXXXIV" do
      subject.to_roman(1984).should == "MCMLXXXIV"
    end
  end

  describe ".to_decimal" do
    LLT::Constants::NUMERALS.each do |dec, rom|
      it "converts #{rom} to #{dec}" do
        subject.to_decimal(rom).should == dec
      end
    end

    it "converts MCMLXXXIV to 1984" do
      subject.to_decimal("MCMLXXXIV").should == 1984
    end
  end
end
