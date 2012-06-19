require 'spec_helper'

describe "31178999 has_sage_flow_transitions takes a hash of transition hashes" do
  it "does something" do
    class Foo < Sample
      has_sage_flow_states :new, :editable, :saved, :locked
      has_sage_flow_transitions :edit => {:new => :editable}, :save => {:editable => :saved}, :lock => {:saved => :locked}
    end
    true.should be_true
  end
  it "Allows creation of a new object" do
    class Foo < Sample
      has_sage_flow_states :new, :editable, :saved, :locked
      has_sage_flow_transitions :edit => {:new => :editable}, :save => {:editable => :saved}, :lock => {:saved => :locked}
    end
    expect do
      f = Foo.new
    end.not_to raise_error
  end
  it "throws an error if state transitions are not represented by a hash" do
    expect do
      class Foo < Sample
        has_sage_flow_states :new, :editable, :saved, :locked
        has_sage_flow_transitions :edit, {:new => :editable}, :save, {:editable => :saved}, :lock, {:saved => :locked}
      end
    end.to raise_error
  end
  it "throws an error if state_transitions is not a hash" do
    expect do
      class Foo < Sample
        has_sage_flow_states :new, :editable, :saved, :locked
        has_sage_flow_transitions :edit, :save, :lock
      end
    end.to raise_error
  end
end
