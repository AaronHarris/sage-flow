require 'spec_helper'

describe "31623733 Transitions in controllers" do
  before(:each) do
    class Foo < Sample
      has_sage_flow_states :new, :open, :saved, :locked
      has_sage_flow_transitions edit: {:new => :open}, save: {open: :saved}, lock: {saved: :locked}
    end
    class FooController < SampleController
      handles_sage_flow_state_for Foo
    end
  end
  describe "For each transition" do
    [:edit, :save, :lock].each do |transition|
      it "Has a perform method" do
        FooController.method_defined?("perform_#{transition.to_s}").should be_true
      end
    end
  end
  it "Changes state to edit using perform_edit" do
    f = Foo.create(name: "Bob", sage_flow_state: "new")
    id = f.id
    f = nil
    fc = FooController.new
    fc.stub(:redirect_to).and_return(200)
    fc.perform_edit(id)
    Foo.find(id).sage_flow_state.should == "open"
  end
  it "Does not change a new state to lock using perform_lock" do
    f = Foo.create(name: "Bob", sage_flow_state: "new")
    id = f.id
    f = nil
    fc = FooController.new
    fc.stub(:redirect_to).and_return(200)
    fc.perform_lock(id)
    Foo.find(id).sage_flow_state.should == "new"
  end
end
