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

    def has_sage_flow_transitions(transitions=Hash.new)
      # Convert &block to Proc
      raise "All transition must be hashes" if (!transitions.kind_of?(Hash) || !transitions.all?{|k,v|v.kind_of?(Hash)})
      raise "All transition names must be symbols" if transitions.any?{|k,v|!k.kind_of?(Symbol)}
      raise "All transitions must use preexisting states" if !transitions.values.all?{|v|(v.flatten(2)-sage_flow_states).empty?}
      if !@sage_flow_transitions
        @sage_flow_transitions ||= Hash.new
        define_singleton_method :sage_flow_transitions do
          @sage_flow_transitions
        end
      end
      @sage_flow_transitions.merge!(transitions)

      if !(self.methods - superclass.methods).include?(:sage_flow_transitions)
        define_singleton_method :sage_flow_transitions do
          superclass.sage_flow_transitions.merge(@sage_flow_transitions)
        end
      end

      transitions.each do |name, change|
        define_method "can_#{name}?" do
          change.keys.flatten.map(&:to_s).include?(sage_flow_state.to_s)
        end

        define_method "do_#{name}" do
          send("sage_flow_state=".to_sym, change[sage_flow_state.to_sym].to_s) if send("can_#{name}?".to_sym)
        end

        define_method "do_#{name}!" do
          send("save!".to_sym) if send("do_#{name}")
        end
      end

      sage_flow_states.each do |state|
        define_method "can_be_#{state}?" do
          transitions.values.map{|c| c.key(state.to_sym)}.compact!.include?(sage_flow_state.to_sym)
        end
      end
    end
  end
end
