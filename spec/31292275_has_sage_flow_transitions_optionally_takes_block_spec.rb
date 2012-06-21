require 'spec_helper'

describe "31292275 has_sage_flow_transitions optionally takes a block" do
  before(:each) do
    class Foo < Sample
      has_sage_flow_states :new, :open, :saved, :locked
      has_sage_flow_transitions edit: {:new => :open}, save: {open: :saved}
      has_sage_flow_transitions lock: {saved: :locked} do
        :locked
      end
    end
  end
  it "Adds the proc to the transitions hash" do
    Foo.t_procs[:lock_proc].should_not be_nil
  end
  it "Runs the proc whenever calling a transition that has a proc" do
    f = Foo.create
    f.sage_flow_state = "saved"
    f.do_lock
    f.sage_flow_state.should == "locked"
  end
  it "Does not run the proc when a transition cannot occur" do
    f = Foo.create
    f.sage_flow_state = "edit"
    f.do_lock
    f.sage_flow_state.should == "edit"
  end
end
