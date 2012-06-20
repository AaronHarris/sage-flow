require 'spec_helper'

describe "31179115 has_sage_flow_transitions adds methods to perform state transitions, e.g. my_object.do_lock" do
  before(:each) do
    class Foo < Sample
      has_sage_flow_states :new, :open, :saved, :locked
      has_sage_flow_transitions edit: {:new => :open}, save: {open: :saved}, lock: {saved: :locked}
    end
  end
  describe "Adds" do
    [:edit,:save,:lock].each do |transition|
      it "do_#{transition} method for each transition" do
        Foo.method_defined?("do_#{transition}".to_s).should be_true
      end
    end
  end
  it "Changes a \'new\' object to \'open\' by calling do_edit" do
    f = Foo.create(name: "Bob", sage_flow_state: "new")
    f.do_edit
    f.sage_flow_state.to_s.should == "open"
  end
  it "Does not change a \'locked\' object by calling do_lock" do
    f = Foo.create(name: "Jim", sage_flow_state: "locked")
    f.do_lock
    f.sage_flow_state.to_s.should == "locked"
  end
  it "Does not change a \'open\' object by calling do_lock" do
    f = Foo.create(name: "Tim", sage_flow_state: "open")
    f.do_lock
    f.sage_flow_state.to_s.should == "open"
  end
  it "Changes a \'saved\' object to \'locked\' by calling do_lock" do
    f = Foo.create(name: "Jack", sage_flow_state: "saved")
    f.do_lock
    f.sage_flow_state.to_s.should == "locked"
  end
  it "Does not change the database when do_lock does work" do
    f = Foo.create(name: "Jack", sage_flow_state: "saved")
    thisid = f.id
    f.do_lock
    g = Foo.find(thisid)
    g.sage_flow_state.to_s.should == "saved"
  end
  it "Does not change the database when do_lock doesn't work" do
    f = Foo.create(name: "Jack", sage_flow_state: "open")
    thisid = f.id
    f.do_lock
    g = Foo.find(thisid)
    g.sage_flow_state.to_s.should == "open"
  end
end
