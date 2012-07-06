require 'spec_helper'

describe "31170425 has_sage_flow_states takes e.g. :editable, :saved, :locked" do
  it "does something" do
    expect do
      class Foo < Sample
        has_sage_flow_states :foo, :bar
      end
    end.not_to raise_error
  end
  it "works with only one state" do
    expect do
      class Foo < Sample
        has_sage_flow_states :bar
      end
    end.not_to raise_error
  end
end
