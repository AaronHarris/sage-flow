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
      # raise "No states specified" if states.empty?
      states.flatten!
      raise "All states must be symbols" if states.flatten.any?{|s|!s.kind_of?(Symbol)}
      raise "All states must be unique" if states.uniq!
      if !@sage_flow_states
        @sage_flow_states = []
        define_singleton_method :sage_flow_states do
          @sage_flow_states
        end
        define_method :validate_sage_flow_state do
          if !self.class.sage_flow_states.map(&:to_s).include?(sage_flow_state)
            errors.add(:sage_flow_state, "State for #{self.class.name} is #{sage_flow_state}; should be one of: #{self.class.sage_flow_states.join(', ')}")
          end
        end
        validate :validate_sage_flow_state
      end
      @sage_flow_states += states

      if !(self.methods - superclass.methods).include?(:sage_flow_states)
        define_singleton_method :sage_flow_states do
          superclass.sage_flow_states + @sage_flow_states
        end
      end
      
      states.each do |state|
        define_method "is_#{state.to_s}?" do
          sage_flow_state.to_s == state.to_s
        end

        define_singleton_method "all_#{state}" do
          where(:sage_flow_state => state.to_s)
        end

        define_singleton_method "all_not_#{state}" do
          where(['sage_flow_state <> ?', state.to_s])
        end
      end

      after_initialize do
        self.sage_flow_state = states[0].to_s if !self.sage_flow_state
      end
    end

    def has_sage_flow_transitions(*state_transitions)
      raise "All transitions must be hashes" if state_transitions.any?{|t|!t.kind_of?(Hash)}
    end
  end
end
