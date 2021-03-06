require 'spec_helper'

describe "31178705 has_sage_flow_states adds a filter to set the state for new records if its not already set default state" do
  before(:each) do
    class Foo < Sample
      has_sage_flow_states :foo, :bar
    end
  end
  it "Should have a value for sage_flow_state" do
    f = Foo.new
    f.sage_flow_state.should_not be_nil
  end
  it "Should have the default value for sage_flow_state equal to the first state" do
    f = Foo.new
    f.is_foo?.should be_true
  end
  it "Should have the default value for sage_flow_state equal to any other state" do
    f = Foo.new
    f.is_bar?.should be_false
  end
end
