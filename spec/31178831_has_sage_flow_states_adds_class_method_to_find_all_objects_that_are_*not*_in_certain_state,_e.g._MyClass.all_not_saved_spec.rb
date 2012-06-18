require 'spec_helper'

describe "31178831 has_sage_flow_states adds class method to find all the objects that are *not* in a certain state, e.g. MyClass.all_not_saved" do
  before(:each) do
    class Foo < Sample
      has_sage_flow_states :zing, :bar
    end
  end
  describe "For state zing, the default" do
    it "has the class method all_not_zing" do
      Foo.methods.include?(:all_not_zing).should be_true
    end
    it "correctly retrieves all_not_zing" do
      obj = []
      f = Foo.create(name: "Bob", sage_flow_state: "zing")
      f = Foo.create(name: "Tim")
      f.sage_flow_state = "bar"
      obj << f
      f.save!
      f = Foo.create(name: "Jim")
      f.sage_flow_state = "bar"
      obj << f
      f.save!
      Foo.all_not_zing.should == obj
    end
  end
  describe "For state bar, not the default" do
    it "has the class method all_not_bar" do
      Foo.methods.include?(:all_not_bar).should be_true
    end
    it "correctly retrieves all_not_bar" do
      obj = []
      f = Foo.create(name: "Bob", sage_flow_state: "bar")
      f.save!
      f = Foo.create(name: "Tim")
      f.sage_flow_state = "zing"
      obj << f
      f.save!
      f = Foo.create(name: "Jim")
      f.sage_flow_state = "zing"
      obj << f
      f.save!
      Foo.all_not_bar.should == obj
    end
  end
end





# describe "For each state" do
#     $states = [:zing, :bar]
#     before(:each) do
#       class Foo < Sample
#         has_sage_flow_states $states
#       end
#     end
#     $states.each do |state|
#       it "has the class method all_not_#{state}" do
#         Foo.methods.include?("all_not#{state}".to_sym).should be_true
#       end
#       it "correctly retrieves all_not_#{state}" do
#         obj = []
#         f = Foo.create(name: "Bob", sage_flow_state: "#{state}")
#         obj << f if f.sage_flow_state != state
#         f = Foo.create(name: "Tim")
#         f.sage_flow_state = "#{state}"
#         f.save!
#         obj << f if f.sage_flow_state != state
#         f = Foo.create(name: "Jim")
#         f.sage_flow_state = "#{$states[$states.index(state)-1]}"
#         obj << f if f.sage_flow_state != state
#         f.save!
#         Foo.send("all_not_#{state}".to_sym).should == obj
#       end
#     end
#   end
