require 'spec_helper'

describe SageFlow do
  it "does something" do
    true.should be_true
  end
  it "can be included" do
    class Foo
      include SageFlow
    end
    f = Foo.new
    f.test_method.should == "Hello World"
  end
  it "adds class methods" do
    class Foo
      include SageFlow
    end
    Foo.class_method.should == "Hello from Class Method"
  end
end