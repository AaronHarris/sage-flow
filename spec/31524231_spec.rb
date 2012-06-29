require 'spec_helper'

describe "31524231 has_sage_flow_transitions adds boolean methods to check whether an object can enter a certain state, e.g. my_object.can_be_locked?" do
  before(:each) do
    class Foo < Sample
      has_sage_flow_states :new, :open, :saved, :locked
      has_sage_flow_transitions edit: {:new => :open}, save: {open: :saved}, lock: {saved: :locked}
    end
  end
  describe "Adds" do
    [:new,:open,:saved,:locked].each do |state|
      it "can_be_#{state}? method for each transition" do
        Foo.method_defined?("can_be_#{state}?".to_s).should be_true
      end
    end
  end
  it "Returns false if an object cannot enter another state based on its current state" do
    f = Foo.create(name: "Bob", sage_flow_state: "open")
    f.can_be_locked?.should be_false
  end
  it "Returns true if an object can enter a state since it is already in that state" do
    f = Foo.create(name: "Bob", sage_flow_state: "saved")
    f.can_be_saved?.should be_false
  end
  it "Returns true if an object can enter a state based on its current state" do
    f = Foo.create(name: "Bob", sage_flow_state: "open")
    f.can_be_saved?.should be_true
  end
end
