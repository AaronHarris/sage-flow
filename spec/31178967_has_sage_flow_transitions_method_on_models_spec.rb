require 'spec_helper'

describe "31178967 has_sage_flow_transitions method on models" do
  it "does something" do
    class Foo < Sample
      has_sage_flow_states
      has_sage_flow_transitions
    end
    true.should be_true
  end
end
