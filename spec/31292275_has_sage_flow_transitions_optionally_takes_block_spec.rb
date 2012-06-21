require 'spec_helper'

describe "31292275 has_sage_flow_transitions optionally takes a block" do
  before(:each) do
    class Foo < Sample
      has_sage_flow_states :new, :open, :saved, :locked
      has_sage_flow_transitions edit: {:new => :open}, save: {open: :saved}
      has_sage_flow_transitions lock: {saved: :locked} do
        $output = "hi"
        :locked
      end
    end
  end
  it "adds the proc to the transitions hash" do
    Foo.t_procs[:lock_proc].should_not be_nil
  end
  it "runs the proc whenever calling a transition that has a proc" do
    f = Foo.new
    f.sage_flow_state = "saved"
    f.do_lock
    $output.should == "hi"
    f.sage_flow_state.should == "locked"
  end
end
