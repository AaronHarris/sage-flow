require 'spec_helper'

describe "31178771 has_sage_flow_states add class method to find all the objects in a certain state (assumes ActiveRecord), e.g. MyClass.all_saved" do
  before(:each) do
    class Foo < Sample
      has_sage_flow_states :zing, :bar
    end
  end
  it "has the class method all_zing" do
    Foo.method_defined?(:all_zing).should be_true
  end
  it "has the class method all_bar" do
    Foo.method_defined?(:all_bar).should be_true
  end
  it "correctly retrieves all_foo" do
    obj = []
    f = Foo.create(name: "Bob", sage_flow_state: 'zing')
    obj << f
    f = Foo.create(name: "Tim")
    obj << f
    f = Foo.create(name: "Jim")
    f.sage_flow_state = "bar"
    f.save!
    Foo.all_zing.should == obj 
  end
end
