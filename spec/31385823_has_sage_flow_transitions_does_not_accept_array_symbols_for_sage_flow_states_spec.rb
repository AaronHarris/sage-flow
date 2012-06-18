require 'spec_helper'

describe "31385823 has_sage_flow_transitions does not accept an array of symbols for sage_flow_states" do
  it "Creates a new class, passing in an array of state symbols" do
  	$states = [:foo, :bar]
    expect do
      class Foo < Sample
        has_sage_flow_states $states
      end
    end.not_to raise_error
  end
end
