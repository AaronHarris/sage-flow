require 'spec_helper'

describe "31171525 has_sage_flow_state adds is_saved? is_editable? is in that state" do
  before(:each) do
    class Foo < Sample
      attr_accessor :sage_flow_state
      has_sage_flow_states :foo, :zing
    end
  end
  it "Has a method for the first state" do
    Foo.method_defined?(:is_foo?).should be_true
  end
  it "Has a method for the second state" do
    Foo.method_defined?(:is_zing?).should be_true
  end
  it "Does not have a method for states it does not have" do
    Foo.method_defined?(:is_bar?).should be_false
  end
  it "Returns true if object is in specified state" do
    f = Foo.new
    f.sage_flow_state = 'foo'
    f.is_foo?.should be_true
  end
  it "Returns false if object is not in specified state" do
    f = Foo.new
    f.sage_flow_state = 'foo'
    f.is_zing?.should be_false
  end
end
