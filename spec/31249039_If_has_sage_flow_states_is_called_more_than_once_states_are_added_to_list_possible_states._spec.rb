require 'spec_helper'

describe "31249039 If has_sage_flow_states is called more than once, the states are added to the list of possible states" do
  describe "within the same class definition" do
    it "does something" do
      expect do 
        class Foo < Sample
          has_sage_flow_states :foo, :bar
          has_sage_flow_states :zing
        end
      end.not_to raise_error
    end
    it "Adds the additional states to the list of possible states" do
      class Foo < Sample
        has_sage_flow_states :foo, :bar
        has_sage_flow_states :zing
      end
      all_states = [:foo, :bar, :zing]
      Foo.sage_flow_states.should == all_states
    end
    it "Does not override the default state" do
      class Foo < Sample
        has_sage_flow_states :foo, :bar
        has_sage_flow_states :zing
      end
      f = Foo.new
      f.sage_flow_state.to_s.should == "foo"
    end
  end
  describe "From a subclass" do
    before(:each) do
      class Foo < Sample
        has_sage_flow_states :foo, :bar
      end
      class SubFoo < Foo
        has_sage_flow_states :zing
      end
    end
    after(:each) do
      Object.send(:remove_const, :SubSubFoo) if Object.const_defined?("SubSubFoo")
    end
    it "does something" do
      true.should be_true
    end
    it "Adds the additional states to the list of possible states for the subclass" do
      all_states = [:foo, :bar, :zing]
      SubFoo.sage_flow_states.should == all_states
    end
    it "Does not add the additional states to the list of possible states for the superclass" do
      super_states = [:foo, :bar]
      Foo.sage_flow_states.should == super_states
    end
    it "Does not allow a superclass object to be in a subclass state" do
      f = Foo.new
      f.sage_flow_state = "zing"
      f.should_not be_valid
    end
    it "Does not override the default state of the superclass" do
      f = Foo.new
      f.sage_flow_state.to_s.should == "foo"
    end
    it "Sets the default state of the subclass to that of the superclass" do
      s = SubFoo.new
      s.sage_flow_state.to_s.should == "foo"
    end
    it "Allows a subclass to be set to a superclass state" do
      s = SubFoo.new
      s.sage_flow_state = "bar"
      s.should be_valid
    end
    it "Allows a subclass to be set to a subclass state" do
      s = SubFoo.new
      s.sage_flow_state = "zing"
      s.should be_valid
    end
    it "Works on additional levels of subclasses" do
      class SubSubFoo < SubFoo
        has_sage_flow_states
      end
      class SubSubSubFoo < SubSubFoo
        has_sage_flow_states :hello, :goodbye
      end
      SubSubSubFoo.sage_flow_states.should == [:foo, :bar, :zing, :hello, :goodbye]
    end
  end
end
