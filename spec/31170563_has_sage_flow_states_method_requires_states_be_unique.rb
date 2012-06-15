require "spec_helper"

describe "31170585 has_flow_states requires states be unique" do
  it "Does not raise exception if all states unique" do
    expect do
      class Foo < Sample
        has_sage_flow_states :foo, :bar
      end
    end.not_to raise_error
  end
  
  it "Raises exception if there is one duplicate state" do
    expect do
      class Foo < Sample
        has_sage_flow_states :foo, :foo, :bar
      end
    end.to raise_error
  end
  
  
end