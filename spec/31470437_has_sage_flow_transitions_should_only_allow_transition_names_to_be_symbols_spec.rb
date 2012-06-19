require 'spec_helper'

describe "31470437 has_sage_flow_transitions should only allow transition names to be symbols" do
  it "Throws an error if a transitions name is not a symbol" do
    expect do
      class Foo < Sample
        has_sage_flow_states :new, :open, :saved, :locked
        has_sage_flow_transitions "edit" => {:new => :open}, 34 => {open: :saved}, lock: {saved: :locked}
      end
    end.to raise_error
  end
  it "Does not throw an error if all transitions name or state are symbols" do
    expect do
      class Foo < Sample
        has_sage_flow_states :new, :open, :saved, :locked
        has_sage_flow_transitions :edit => {:new => :open}, :save => {open: :saved}, lock: {saved: :locked}
      end
    end.not_to raise_error
  end
end
