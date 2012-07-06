require 'spec_helper'

describe "31623733 Transitions in controllers" do
  before(:each) do
    class Foo2 < Sample
      has_sage_flow_states :new, :open, :saved, :locked
      has_sage_flow_transitions edit: {:new => :open}, save: {open: :saved}, lock: {saved: :locked}
    end
    class Foo2Controller < SampleController
      handles_sage_flow_state_for Foo2
    end
  end
  after(:each) do
    Object.send(:remove_const, :Foo2)
    Object.send(:remove_const, :Foo2Controller)
  end
  describe "For each transition" do
    [:edit, :save, :lock].each do |transition|
      it "Has a perform method" do
        Foo2Controller.method_defined?("perform_#{transition.to_s}").should be_true
      end
    end
  end
  it "Changes state to edit using perform_edit" do
    f = Foo2.create(name: "Bob", sage_flow_state: "new")
    id = f.id
    fc = Foo2Controller.new
    fc.stub(:redirect_to).and_return(200)
    fc.perform_edit(f.id)
    Foo2.find(id).sage_flow_state.should == "open"
  end
  it "Does not change a new state to lock using perform_lock" do
    f = Foo2.create(name: "Bob", sage_flow_state: "new")
    id = f.id
    f = nil
    fc = Foo2Controller.new
    fc.stub(:redirect_to).and_return(200)
    fc.perform_lock(id)
    Foo2.find(id).sage_flow_state.should == "new"
  end
end
