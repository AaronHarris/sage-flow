require 'spec_helper'

describe "31179073 has_sage_flow_transitions adds boolean methods to check whether each transition can be applied, e.g. my_object.can_lock?" do
  before(:each) do
    class Foo < Sample
      has_sage_flow_states :new, :open, :saved, :locked
      has_sage_flow_transitions edit: {:new => :open}, save: {open: :saved}, lock: {saved: :locked}
    end
  end
  describe "Adds" do
    [:edit,:save,:lock].each do |transition|
      it "can_#{transition}? method for each transition" do
        Foo.method_defined?("can_#{transition}?".to_s).should be_true
      end
    end
  end
  it "Returns true if an object can perform a transition based on its current state" do
    f = Foo.create(name: "Bob", sage_flow_state: :open)
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
    f = Foo.create(name: "Bob", sage_flow_state: :open)
    f.can_edit?.should be_false
  end
end
