require 'spec_helper'

describe "32041937 has_sage_flow_states also takes in a hash with symbols pointing to strings that are the states' display name" do
  before(:each) do
    class Foo < Sample
      has_sage_flow_states :new, :open, :saved, :locked
    end
  end
  it "has a class method display_states" do
    Foo.methods.include?("display_states".to_sym).should be_true
  end
  it "display_states returns a hash of each state pointing to a titlecase string of the state" do
    Foo.display_states.should == {new: "New", open: "Open", saved: "Saved", locked: "Locked"}
  end
  describe "Accepts a hash of state symbols pointing to display strings as input" do
    before(:each) do
      class Foo3 < Foo
        has_sage_flow_states archived_saved: "Archived (was Saved)", archived_locked: "Archived (was Locked)"
      end
    end
    after(:each) do
      Object.send(:remove_const, :Foo3) if Object.const_defined?("Foo3")
    end
    it "should add these display states to the total hash of display_states" do
      Foo3.display_states.should == {new: "New", open: "Open", saved: "Saved", locked: "Locked", archived_saved: "Archived (was Saved)", archived_locked: "Archived (was Locked)"}
    end
    it "returns a string of the display state for a particular object" do
      f = Foo3.create(name: "Bob", sage_flow_state: "archived_saved")
      Foo3.all_archived_saved.first.display_state.should == "Archived (was Saved)"
    end
  end
  describe "Accepts a hash that overwrites preexisting states" do
    it "just works in the same class" do
      class Foo < Sample
        has_sage_flow_states new: "Another new", invalid: 'Invalid'
      end
      Foo.display_states.should == {new: "Another new", open: "Open", saved: "Saved", locked: "Locked", invalid: "Invalid"}
    end
    it "just works in a sub-subclass" do
      class SubFoo < Foo; end
      class SubSubFoo < SubFoo
        has_sage_flow_states new: "Another new", invalid: 'Invalid'
      end
      SubSubFoo.display_states.should == {new: "Another new", open: "Open", saved: "Saved", locked: "Locked", invalid: "Invalid"}
    end
    it "Allows a sub-subclass object to have a superclass display_state" do
      class SubFoo < Foo; end
      class SubSubFoo < SubFoo
        has_sage_flow_states new: "Another new", invalid: 'Invalid'
      end
      SubSubFoo.create(name: "Bob", sage_flow_state: "new")
      SubSubFoo.all_new.first.display_state.should == "Another new"
    end
  end
  describe "Accepts an array as input for a hash, in addition to regular symbols" do
    before(:each) do
      class Foo
        has_sage_flow_states :exported, [:archived_saved, :archived_locked] => {separator: "(was", suffix: ")"}
      end
    end
    it "just works" do
      true.should be_true
    end
    it "gives the correct display_states" do
      Foo.display_states.should == {new: "New", open: "Open", saved: "Saved", locked: "Locked", exported: "Exported", archived_saved: "Archived (was Saved)", archived_locked: "Archived (was Locked)"}
    end
  end
  it "raises an error if a symbol is not used in a hash" do
    expect do
      class Foo
        has_sage_flow_states :exported, [:archived_saved, :archived_locked] => {separator: "(was", suffix: ")"}, 34 => "", "newstate" => "New State"
      end
    end.to raise_error
  end
  describe "For a subclass" do
    before(:each) do
      class SubFoo < Foo; end
      class SubSubFoo < SubFoo
        has_sage_flow_states new: "Another new", invalid: 'Invalid'
      end
    end
    it "returns everything in the proper state" do
      f = Foo.create(name: "Foo1", sage_flow_state: "new")
      f2 = Foo.create(name: "Foo2", sage_flow_state: "open")
      s = SubFoo.create(name: "SubFoo1", sage_flow_state: "new")
      ss = SubSubFoo.create(name: "SubSubFoo1", sage_flow_state: "new")
      SubSubFoo.all_new.map{|o| [o.id, o.name, o.sage_flow_state, o.type]}.should == [ss].map{|o| [o.id, o.name, o.sage_flow_state, o.type]}
    end
  end
end
