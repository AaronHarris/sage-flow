require 'spec_helper'

describe "31623679 Current state in controllers" do
  before(:each) do
    class Foo < Sample
      has_sage_flow_states :new, :open, :saved, :locked
      has_sage_flow_transitions edit: {:new => :open}, save: {open: :saved}, lock: {saved: :locked}
    end
  end
  it "Raises an exception if the given model name is not a type of ActiveRecord" do
    expect do
      class Bar
      end
      class FooController < SampleController
        handles_sage_flow_state_for Bar
      end
    end.to raise_error
  end
  describe "Adds the method handles_sage_flow_state_for which" do
    before(:each) do 
      class FooController < SampleController
        handles_sage_flow_state_for Foo
      end
    end
    it "does something" do
      true.should be_true
    end
    it "Adds the method sage_flow_state" do
      FooController.method_defined?("sage_flow_state").should be_true
    end
    it "Returns the state for an object" do
      f = Foo.create(name: "Bob", sage_flow_state: "new")
      id = f.id
      f = nil
      fc = FooController.new
      fc.sage_flow_state(id).should == "new"
    end
  end
end
