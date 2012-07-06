require 'spec_helper'

describe "32380925 has_sage_flow_states takes in bootstrap badge types or colors for each state" do
  before(:each) do
    class Foo0925 < Sample
      has_sage_flow_states new: {color: "red"}, open: {badge: "warning"}, saved: {badge: "info"}, locked: {badge: "success"}
      has_sage_flow_transitions edit: {:new => :open}, save: {open: :saved}, lock: {saved: :locked}
    end
  end
  it "does something" do
    true.should be_true
  end
  it "returns the badge type color mapped to the state" do
    Foo0925.sage_flow_colors.should == {new: "red", open: "orange", saved: "blue", locked: "green"}
  end
  it "returns the badge color type mapped to the state" do
    Foo0925.sage_flow_badges.should == {new: "important", open: "warning", saved: "info", locked: "success"}
  end
  it "returns the bootstrap badge hash when called on a model" do
    Foo0925.badge_colors.should == {"gray"=>"default", "green"=>"success", "orange"=>"warning", "red"=>"important", "blue"=>"info", "black"=>"inverse"}
  end
end
