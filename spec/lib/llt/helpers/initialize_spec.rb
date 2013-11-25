require 'spec_helper'

describe LLT::Helpers::Initialize do
  class Dummy
    include LLT::Helpers::Initialize
  end

  let(:dummy) { Dummy.new }

  describe "#extract_args!" do
    let(:args) { { test1: 1, test2: 2, test3: 3 } }

    context "with two arguments" do
      it "extracts args given in a hash and maps given keys inside an Array to instance variables" do
        dummy.extract_args!(args, [:test1, :test2])
        dummy.instance_variable_get("@test1").should == 1
        dummy.instance_variable_get("@test2").should == 2
        dummy.instance_variable_get("@test3").should be_nil
      end
    end

    context "with one argument" do
      it "throws an error when #init_keys is not implemented" do
        expect { dummy.extract_args!(args) }.to raise_error
      end

      it "maps the keys given in #init_keys" do
        class Dummy
          def init_keys
            %i{ test1 test2 }
          end
        end

        dummy.extract_args!(args)
        dummy.instance_variable_get("@test1").should == 1
        dummy.instance_variable_get("@test2").should == 2
        dummy.instance_variable_get("@test3").should be_nil
      end
    end
  end

  describe "#extract_normalized_args!" do
    it "extracts args and normalizes them" do
      class Dummy; def init_keys; %i{ inflection_class }; end; end

      dummy.extract_normalized_args!(itype: 1)
      dummy.instance_variable_get("@inflection_class").should == 1
    end
  end
end
