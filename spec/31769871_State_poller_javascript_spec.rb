require 'spec_helper'

describe "31769871 State poller javascript" do
  before(:each) do
    class Foo < Sample
      has_sage_flow_states :new, :open, :saved, :locked
      has_sage_flow_transitions edit: {:new => :open}, save: {open: :saved}, lock: {saved: :locked}
    end
  end
  it "does something" do
    f = Foo.new
  end
end
