module SageFlow
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def class_method
      'Hello from Class Method'
    end
  end
  
  def test_method
    "Hello World"
  end
end
