require 'spec_helper'

describe LLT::Helpers::PrimitiveCache do
  class Dummy
    include LLT::Helpers::PrimitiveCache
  end

  describe "#cached" do
    it "takes a key and a block, whose result gets cached" do
      d = Dummy.new
      d.enable_cache
      d.cached(:a) { 1 }.should == 1
      d.cached(:a) { 2 }.should == 1
    end

    it "is disabled by default" do
      d = Dummy.new
      d.cached(:a) { 1 }.should == 1
      d.cached(:a) { 2 }.should == 2
    end
  end

  describe "#cache" do
    it "returns the hash cache of the class" do
      d = Dummy.new
      d.enable_cache
      d.cached(:a) { 1 }
      d.cache.should == Dummy.cache
    end

    it "is shared across instances of a class" do
      d1 = Dummy.new
      d2 = Dummy.new
      d1.enable_cache
      d2.enable_cache
      d1.cached(:a) { 1 }
      d1.cached(:b) { 2 }

      cache = Dummy.cache
      d1.cache.should == cache
      d2.cache.should == cache
    end
  end

  describe "#enable_cache" do
    it "enables the cache" do
      d = Dummy.new
      d.enable_cache
      d.cached(:a) { 1 }.should == 1
      d.cached(:a) { 2 }.should == 1
    end
  end

  describe "#disable_cache" do
    it "disables the cache" do
      d = Dummy.new
      d.enable_cache
      d.cached(:a) { 1 }.should == 1
      d.cached(:a) { 2 }.should == 1

      d.disable_cache
      d.cached(:a) { 3 }.should == 3
    end
  end
end
