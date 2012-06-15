=begin
  SageFlow gem
  Copyright (c) 2012 The Hathersage Group, Inc.
  All Rights Reserved
  The Hathersage Group, Inc.
  9415 Culver Blvd
  Culver City, CA 90232
  http://www.hathersagegroup.com
=end

module SageFlow

  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def has_sage_flow_states(*states)
      raise "All states must be symbols" if states.any?{|s|!s.kind_of?(Symbol)}
      raise "All states must be unique" if states.uniq!
      validates_presence_of :sage_flow_state
      validates_inclusion_of :sage_flow_state, :in => states.map(&:to_s), :message => "State for #{name.demodulize} is %{value}; should be one of: #{states.join(', ')}"
      
      states.each do |state|
        define_method "is_#{state.to_s}?" do
          sage_flow_state.to_s == state.to_s
        end

        # self.instance_eval do
        #   define_method "all_#{state}" do
        #     where(:sage_flow_state => state.to_s)
        #   end
        # end
      end

      after_initialize do
        self.sage_flow_state = states[0].to_s if !self.sage_flow_state
      end
    end
  end
end
