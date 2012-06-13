require 'spec_helper'

describe "31170425 has_sage_flow_states takes e.g. :editable, :saved, :locked" do
  it "does something" do
    class Foo < FakeModel
      has_sage_flow_states :foo, :bar
    end
  end  
end
