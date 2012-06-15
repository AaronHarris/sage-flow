require 'spec_helper'

describe "31171489 has_sage_flow_states adds validator for if sage_flow_state not one of the choices" do
  it "Is invalid when sage_flow_state is not one of the states" do
    class Foo < Sample
      attr_accessor :sage_flow_state
      has_sage_flow_states :foo, :bar
    end
    f = Foo.new
    f.sage_flow_state = "zing"
    f.valid?.should be_false
  end
  it "Is valid when sage_flow_state is one of the proper states" do
    class Foo < Sample
      attr_accessor :sage_flow_state
      has_sage_flow_states :foo, :bar
    end
    f = Foo.new
    f.sage_flow_state = "foo"
    f.valid?.should be_true
  end
end
