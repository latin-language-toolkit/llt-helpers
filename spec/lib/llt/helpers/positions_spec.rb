require 'spec_helper'

describe LLT::Helpers::Positions do
  class P
    attr_accessor :position

    include LLT::Helpers::Positions

    def initialize(position)
      @position = position
    end
  end

  let(:ab) { [P.new(1), P.new(5)] }

  describe "#===" do
    it "is true when two objects have the same position" do
      a = P.new(1)
      b = P.new(1)
      c = P.new(2)

      (a === b).should be_true
      (a === c).should be_false
    end
  end

  describe "#<, #>, #>=, #<=, <=>" do
    it "do as expected in regards to @position" do
      a = P.new(1)
      b = P.new(1)
      c = P.new(2)

      (a < c).should be_true
      (a <=> b).should be_zero
    end
  end

  describe "#surrounding" do
    it "returns the fixnum value of the position before and after an object" do
      a = P.new(1)
      a.surrounding.should == [0, 2]
    end
  end

  describe "#distance_to" do
    it "returns the distance to another object" do
      a, b = ab

      a.distance_to(b).should == 4
    end

    it "returns a negative fixnum when the receiver is behind the object passed in as argument" do
      a, b = ab

      b.distance_to(a).should == -4
    end

    it "a negative result is absoluted, when a true flag is passed" do
      a, b = ab
      b.distance_to(a, true).should == 4
    end
  end

  describe "#close_to?" do
    it "responds to true if objects are positionally close to each other" do
      a = P.new(1)
      b = P.new(2)

      a.close_to?(b).should be_true
      b.close_to?(a).should be_true
    end

    it "takes a fixnuma argument to declare a range where close is considered to be true" do
      a, b = ab # 1, 5
      a.close_to?(b, 3).should be_false
      a.close_to?(b, 4).should be_true
      a.close_to?(b, 5).should be_true
    end
  end

  describe "#between?" do
    it "returns true if the receiver is between arguments a and b" do
      a, b = ab
      c = P.new(3)
      d = P.new(6)

      c.between?(a, b).should be_true
      d.between?(a, b).should be_false
    end
  end

  describe "#range_with" do
    it "returns the positions between the receiver and the passed in object in an array - excludes start and end" do
      a, b = ab
      a.range_with(b).should ==  [2, 3, 4]
    end

    it "results are always sorted" do
      a, b = ab
      b.range_with(a).should == a.range_with(b)
    end

    it "returns a real Range object with a true flag" do
      a, b = ab
      a.range_with(b, true).should == (2...5)
    end
  end
end
