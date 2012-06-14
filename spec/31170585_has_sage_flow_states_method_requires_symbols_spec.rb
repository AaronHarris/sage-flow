require "spec_helper"

describe "31170585 has_flow_states requires symbols" do
  after(:each) do
    Object.send(:remove_const, :Foo)
  end
  it "Does not raise exception if all symbols" do
    expect do
      class Foo < FakeModel
        has_sage_flow_states :foo, :bar
      end
    end.not_to raise_error
  end
  
  it "Raises exception if one not a symbol" do
    expect do
      class Foo < FakeModel
        has_sage_flow_states :foo, 34
      end
    end.to raise_error
  end
  
  
end