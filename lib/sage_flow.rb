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
      validates_inclusion_of :sage_flow_state, :in => states.map(&:to_s), :message => "%s is not one of the sage_flow_states"
    end
  end
end
