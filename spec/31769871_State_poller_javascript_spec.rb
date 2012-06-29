require 'spec_helper'

describe "31769871 State poller javascript" do
  before(:each) do
    class Foo < Sample
      has_sage_flow_states :new, :open, :saved, :locked
      has_sage_flow_transitions edit: {:new => :open}, save: {open: :saved}, lock: {saved: :locked}
    end
    class FooController < SampleController
      handles_sage_flow_state_for Foo
    end
  end
  it "does something" do
    expect do
      f = Foo.new
      fc = FooController.new
    end.not_to raise_error
  end
  it "returns a jquery-wrapped javascript function to poll the server for a state change" do
    f = Foo.create(name: "Bob")
    fc = FooController.new
    fc.stub(:render)
    fc.sage_flow_state_poller(f.id).should == "$(function(){
  var foo_interval_1 = setInterval(function(){
    $.get('/foos/1/sage_flow_state.txt',function(state){
      if (state != 'new'}) {
        clearInterval(foo_interval_1);
        location.reload();
      }
    })
  }, 1000);
})"
  end
end
