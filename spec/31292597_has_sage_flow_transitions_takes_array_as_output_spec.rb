require 'spec_helper'

describe "31292597 has_sage_flow_transitions takes an array as output" do
  before(:each) do
    class Foo < Sample
      has_sage_flow_states :new, :open, :saved, :locked, :invalid
      has_sage_flow_transitions edit: {:new => :open}, save: {open: :saved}
      has_sage_flow_transitions lock: {saved: [:locked, :invalid]} {
        :invalid }
    end
  end
  it "adds the proc to the transitions hash" do
    Foo.t_procs[:lock_proc].should_not be_nil
  end
  it "Runs the proc whenever calling a transition that has a proc" do
    f = Foo.create
    f.sage_flow_state = "saved"
    output = double('output')
    f.do_lock
    f.sage_flow_state.should == "invalid"
  end
  it "Does not run the proc when a transition cannot occur" do
    f = Foo.create
    f.sage_flow_state = "open"
    f.do_lock
    f.sage_flow_state.should == "open"
  end
  it "Does not change the state if the proc returns an invalid state" do
    class Foo
      has_sage_flow_transitions lock: {saved: [:locked, :invalid]} {
        :open
      }
    end
    f = Foo.create
    f.sage_flow_state = "saved"
    expect{f.do_lock}.to raise_error
    f.sage_flow_state.should == "saved"
  end
  it "Raises an error if has_sage_flow_transitions is given an array as output but no block is supplied" do
    expect do
      class Foo
        has_sage_flow_transitions lock: {saved: [:locked, :invalid]} 
      end
    end.to raise_error
  end
end
