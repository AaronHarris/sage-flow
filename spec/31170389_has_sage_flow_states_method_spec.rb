require 'spec_helper'

describe "31170389 has_sage_flow_states method" do
  after(:each) do
    Object.send(:remove_const, :Foo)
  end
  it "does something" do
    class Foo < FakeModel
      has_sage_flow_states
    end
    true.should be_true
  end
end
