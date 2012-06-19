require 'spec_helper'

describe "31292053 If has_sage_flow_transitions is called more than once, the transitions are added to the list of possible transitions" do
  describe "within the same class definition" do
    before(:each) do
      class Foo < Sample
        has_sage_flow_states :new, :open, :saved, :locked
        has_sage_flow_transitions edit: {:new => :open}
        has_sage_flow_transitions save: {open: :saved}, lock: {saved: :locked}
      end
    end
    it "does something" do
      true.should be_true
    end
    it "Adds the additional states to the list of possible states" do
      all_transitions = {edit: {:new => :open}, save: {open: :saved}, lock: {saved: :locked}}
      Foo.sage_flow_transitions.should == all_transitions
    end
    it "Allows an object to be instantiated" do
      expect do
        f = Foo.new
      end.not_to raise_error
    end
  end
  describe "From a subclass" do
    before(:each) do
      class Foo < Sample
        has_sage_flow_states :new, :open, :saved
        has_sage_flow_transitions edit: {:new => :open}
      end
      class SubFoo < Foo
        has_sage_flow_states :locked
        has_sage_flow_transitions save: {open: :saved}, lock: {saved: :locked}
      end
      class OtherSubFoo < Foo
        has_sage_flow_states
        has_sage_flow_transitions save: {open: :saved}
      end
    end
    after(:each) do
      Object.send(:remove_const, :OtherSubFoo) if Object.const_defined?("OtherSubFoo")
      Object.send(:remove_const, :SubSubFoo) if Object.const_defined?("SubSubFoo")
      Object.send(:remove_const, :SubSubSubFoo) if Object.const_defined?("SubSubSubFoo")
    end
    it "does something" do
      true.should be_true
    end
    it "Adds the additional transitions to the list of transitions for the subclass" do
      all_transitions = {edit: {:new => :open}, save: {open: :saved}, lock: {saved: :locked}}
      SubFoo.sage_flow_transitions.should == all_transitions
    end
    it "Does not add the additional transitions to the list of transitions for the superclass" do
      super_transitions = {edit: {:new => :open}}
      Foo.sage_flow_transitions.should == super_transitions
    end
    it "Adds the additional transitions to the list of transitions for the other subclass" do
      other_transitions = {edit: {:new => :open}, save: {open: :saved}}
      OtherSubFoo.sage_flow_transitions.should == other_transitions
    end
    it "Works on additional levels of subclasses" do
      class SubSubFoo < SubFoo
        has_sage_flow_states :discarded
        has_sage_flow_transitions
      end
      class SubSubSubFoo < SubSubFoo
        has_sage_flow_states
        has_sage_flow_transitions discard: {locked: :discarded}
      end
      total_transitions = {edit: {:new => :open}, save: {open: :saved}, lock: {saved: :locked}, discard: {locked: :discarded}}
      SubSubSubFoo.sage_flow_transitions.should == total_transitions
    end
  end
end
