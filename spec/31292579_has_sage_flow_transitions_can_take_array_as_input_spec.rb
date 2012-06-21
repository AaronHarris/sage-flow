require 'spec_helper'

describe "31292579 has_sage_flow_transitions can take an array as an input" do
  before(:each) do
    class Foo < Sample
      has_sage_flow_states :new, :open, :saved, :locked
      has_sage_flow_transitions edit: {[:new,:saved] => :open}, save: {[:new,:open] => :saved}, lock: {saved: :locked}
    end
  end
  it "does something" do
    true.should be_true
  end
  it "Allows creation of an object" do
    expect do
      f = Foo.new
      f.save!
    end.not_to raise_error
  end
  describe "Works for can_transition? methods" do 
    it "Returns true if an object can perform a transition based on its current state" do
      f = Foo.create(name: "Bob", sage_flow_state: "open")
      f.can_save?.should be_true
    end
    it "Returns false if an object cannot perform a transition" do
      f = Foo.new
      f.can_lock?.should be_false
    end
    it "Returns false if an object cannot perform a transition" do
      f = Foo.new
      f.can_edit?.should be_true
    end
    it "Returns true if an object can perform another transition" do
      f = Foo.create(name: "Bob", sage_flow_state: "open")
      f.can_edit?.should be_false
    end
  end
  describe "Works for do_transition methods" do
    it "Changes a \'new\' object to \'open\' by calling do_edit" do
      f = Foo.create(name: "Bob", sage_flow_state: "new")
      f.do_edit
      f.sage_flow_state.to_s.should == "open"
    end
    it "Changes a \'saved\' object to \'open\' by calling do_edit" do
      f = Foo.create(name: "Bob", sage_flow_state: "new")
      f.do_edit
      f.sage_flow_state.to_s.should == "open"
    end
    it "Does not change a \'locked\' object to \'open\' by calling do_edit" do
      f = Foo.create(name: "Bob", sage_flow_state: "locked")
      f.do_edit
      f.sage_flow_state.to_s.should == "locked"
    end
    it "Does not change a \'locked\' object by calling do_lock" do
      f = Foo.create(name: "Jim", sage_flow_state: "locked")
      f.do_lock
      f.sage_flow_state.to_s.should == "locked"
    end
    it "Does not change a \'open\' object by calling do_lock" do
      f = Foo.create(name: "Tim", sage_flow_state: "open")
      f.do_lock
      f.sage_flow_state.to_s.should == "open"
    end
    it "Changes a \'saved\' object to \'locked\' by calling do_lock" do
      f = Foo.create(name: "Jack", sage_flow_state: "saved")
      f.do_lock
      f.sage_flow_state.to_s.should == "locked"
    end
    it "Does not change the database when do_lock does work" do
      f = Foo.create(name: "Jack", sage_flow_state: "saved")
      thisid = f.id
      f.do_lock
      g = Foo.find(thisid)
      g.sage_flow_state.to_s.should == "saved"
    end
    it "Does not change the database when do_lock doesn't work" do
      f = Foo.create(name: "Jack", sage_flow_state: "open")
      thisid = f.id
      f.do_lock
      g = Foo.find(thisid)
      g.sage_flow_state.to_s.should == "open"
    end
  end
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
      class SubFoo < Foo
        has_sage_flow_states :invalid
        has_sage_flow_transitions edit: {:new => :saved}, validate: {[:saved,:invalid] => :locked}
      end
      class OtherSubFoo < Foo
        has_sage_flow_states 
        has_sage_flow_transitions edit: {open: :saved}
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
      all_transitions = {edit: {:new => :saved}, save: {new: :saved, open: :saved}, lock: {saved: :locked}, validate: {saved: :locked, invalid: :locked}}
      SubFoo.sage_flow_transitions.should == all_transitions
    end
    it "Does not add the additional transitions to the list of transitions for the superclass" do
      super_transitions = {edit: {new: :open, saved: :open}, save: {new: :saved, open: :saved}, lock: {saved: :locked}}
      Foo.sage_flow_transitions.should == super_transitions
    end
    it "Adds the additional transitions to the list of transitions for the other subclass" do
      other_transitions = {edit: {open: :saved}, save: {new: :saved, open: :saved}, lock: {saved: :locked}}
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
      total_transitions = {edit: {:new => :saved}, save: {new: :saved, open: :saved}, lock: {saved: :locked}, validate: {saved: :locked, invalid: :locked}, discard: {locked: :discarded}}
      SubSubSubFoo.sage_flow_transitions.should == total_transitions
    end
  end
end