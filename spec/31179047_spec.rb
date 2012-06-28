require 'spec_helper'

describe "31179047 has_sage_flow_transitions throws an exception if the states referenced arent in the has_sage_flow_states lists" do |variable|
  it "Throws an Exception when any states not in has_sage_flow_states" do
    expect do
      class Foo < Sample
        has_sage_flow_states :new, :editable
        has_sage_flow_transitions :edit => {:new => :editable}, :save => {:editable => :saved}, :lock => {:saved => :locked}
      end
    end.to raise_error
  end
  it "Does not throws an Exception when all states in has_sage_flow_states" do
    expect do
      class Foo < Sample
        has_sage_flow_states :new, :editable, :saved, :locked
        has_sage_flow_transitions :edit => {:new => :editable}, :save => {:editable => :saved}, :lock => {:saved => :locked}
      end
    end.not_to raise_error
  end
  it "Does not throws an Exception when input states is an array" do
    expect do
      class Foo < Sample
        has_sage_flow_states :new, :editable, :saved, :locked
        has_sage_flow_transitions :edit => {[:new,:locked] => :editable}, :save => {[:new,:editable] => :saved}, :lock => {:saved => :locked}
      end
    end.not_to raise_error
  end
end