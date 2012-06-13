require 'spec_helper'

describe "31170407 has_sage_flow_states adds validator to test for presence of sage_flow_state field" do
  it "Throws exception when field is not defined at all" do
    expect do
      class Foo < FakeModel
        include SageFlow
        has_sage_flow_states
      end
      Foo.new.valid?
    end.to raise_error
  end
  it "Is invalid when there is no value" do
    class Foo < FakeModel
      include SageFlow
      attr_accessor :sage_flow_state
      has_sage_flow_states
    end
    Foo.new.valid?.should be_false
  end
  it "is valid when has a value" do
    class Foo < FakeModel
      include SageFlow
      attr_accessor :sage_flow_state
      has_sage_flow_states
    end
    f = Foo.new
    f.sage_flow_state = "bar"
    f.valid?.should be_true
  end
end
