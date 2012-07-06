require 'spec_helper'

describe "32386029 has_sage_flow_states takes in bootstrap badges and adds instance method to get the current object's badge type and color" do
  before(:each) do
    class Foo6029 < Sample
      has_sage_flow_states :new, open: {badge: "warning"}, saved: {badge: "info"}, locked: {badge: "success"}, invalid: {color: "white"}
      has_sage_flow_transitions edit: {:new => :open}, save: {open: :saved}, lock: {saved: :locked}
    end
  end
  it "just works" do
    true.should be_true
  end
  it "Adds an instance method sage_flow_badge" do
    Foo6029.method_defined?(:sage_flow_badge).should be_true
  end
  it "Adds an instance method sage_flow_color" do
    Foo6029.method_defined?(:sage_flow_color).should be_true
  end
  describe "corectly returns an object's badge type" do
    it "for new" do
      f = Foo6029.create(name: "Bob")
      f.sage_flow_badge.should == "default"
      f.sage_flow_color.should == "gray"
    end
    it "for open" do
      f = Foo6029.create(name: "Bill", sage_flow_state: "open")
      f.sage_flow_badge.should == "warning"
      f.sage_flow_color.should == "orange"
    end
    it "for save" do
      f = Foo6029.create(name: "Tim", sage_flow_state: "saved")
      f.sage_flow_badge.should == "info"
      f.sage_flow_color.should == "blue"
    end
    it "for locked" do
      f = Foo6029.create(name: "Tom", sage_flow_state: "locked")
      f.sage_flow_badge.should == "success"
      f.sage_flow_color.should == "green"
    end
    it "for invalid" do
      f = Foo6029.create(name: "Tom", sage_flow_state: "invalid")
      f.sage_flow_badge.should == "default"
      f.sage_flow_color.should == "white"
    end
  end
  describe "plays nicely with the database" do
    it "for new" do
      f = Foo6029.create(name: "Bob")
      Foo6029.all_new.first.sage_flow_badge.should == "default"
      Foo6029.all_new.first.sage_flow_color.should == "gray"
    end
    it "for saved" do
      f = Foo6029.create(name: "Bob", sage_flow_state: "saved")
      Foo6029.all_saved.first.sage_flow_badge.should == "info"
      Foo6029.all_saved.first.sage_flow_color.should == "blue"
    end
  end
end
