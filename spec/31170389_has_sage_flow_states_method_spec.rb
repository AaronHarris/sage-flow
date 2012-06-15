require 'spec_helper'

describe "31170389 has_sage_flow_states method" do
  it "does something" do
    class Foo < Sample
      has_sage_flow_states
    end
    true.should be_true
  end
end
