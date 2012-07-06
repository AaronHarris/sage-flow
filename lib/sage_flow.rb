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
    def sage_flow_fix_hash!(hash)
      if arrs = hash.keys.select{|k| k.kind_of?(Array)} 
        arrs.each do |arr|
          arr.each do |a|
            hash[a] = hash[arr].kind_of?(Symbol) ? hash[arr] : hash[arr].dup
          end
          hash.delete(arr)
        end
      end
      hash
    end
    
    def has_sage_flow_states(*states)
      states.flatten!
      raise "All states must be symbols" if states.map{|e| e.kind_of?(Hash) ? e.keys : e}.flatten.any?{|s|!s.kind_of?(Symbol)}
      raise "All states must be unique" if states.map{|e| e.kind_of?(Hash) ? e.keys : e}.flatten.uniq!
      states = states.flatten.inject({}) {|m,o| o.kind_of?(Hash) ? m.merge(o) : m.merge(o=>{})}
      states = sage_flow_fix_hash!(states)
      unless respond_to? :sage_flow_states
        define_singleton_method :sage_flow_states_info do
          @sage_flow_states_info ? superclass.sage_flow_states_info.merge(@sage_flow_states_info) : superclass.sage_flow_states_info rescue @sage_flow_states_info.dup
        end
        define_singleton_method :sage_flow_states do
          sage_flow_states_info.keys
        end
        define_singleton_method :display_states do
          Hash[sage_flow_states_info.map{|s,o| o[:display] ? [s,o[:display]] : [s,s.to_s.titleize]}]
        end
        define_method :validate_sage_flow_state do
          if !self.class.sage_flow_states.map(&:to_s).include?(sage_flow_state)
            errors.add(:sage_flow_state, "State for #{self.class.name} is #{sage_flow_state}; should be one of: #{self.class.sage_flow_states.join(', ')}")
          end
        end
        validate :validate_sage_flow_state
        define_method :display_state do
          self.class.sage_flow_states_info[sage_flow_state.to_sym][:display]
        end
      end
      
      states.each do |state, options|
        define_method "is_#{state.to_s}?" do
          sage_flow_state.to_s == state.to_s
        end

        define_singleton_method "all_#{state}" do
          where(:sage_flow_state => state.to_s)
        end

        define_singleton_method "all_not_#{state}" do
          where(['sage_flow_state <> ?', state.to_s])
        end

        options = states[state] = {display: options} if options.kind_of?(String)
        options[:display] ||= state.to_s.titleize
        options[:display] = options[:display].split.zip([*options.delete(:separator)]).flatten.compact.join(' ') if options[:separator]
        options[:display]<< options.delete(:suffix) if options[:suffix]
        options[:display].prepend(options.delete[:prefix]) if options[:prefix]
      end
      
      @sage_flow_states_info ? @sage_flow_states_info.merge!(states) : @sage_flow_states_info = states

      after_initialize do
        self.sage_flow_state = states.keys.first.to_s unless self.sage_flow_state
      end
      @@badge_colors ||= {"gray"=>"", "green"=>"success", "orange"=>"warning", "red"=>"important", "blue"=>"info", "black"=>"inverse"}
    end

    def has_sage_flow_transitions(transitions=Hash.new, &block)
      raise "All transition must be hashes" if (!transitions.kind_of?(Hash) || !transitions.all?{|k,v|v.kind_of?(Hash)})
      raise "All transition names must be symbols" if transitions.any?{|k,v|!k.kind_of?(Symbol)}
      raise "All transitions must use preexisting states: #{sage_flow_states.join(', ')}" if !transitions.values.all?{|h|(h.flatten(2)-sage_flow_states).empty?}
      raise "All output state arrays must be passed with a block" if !block_given? && transitions.values.any?{|h| h.values.any?{|o| o.kind_of?(Array)}}
      unless respond_to? :sage_flow_transitions
        define_singleton_method :sage_flow_transitions do
          @sage_flow_transitions ? superclass.sage_flow_transitions.merge(@sage_flow_transitions) : superclass.sage_flow_transitions rescue @sage_flow_transitions.dup
        end
        define_singleton_method :t_procs do
          @t_procs ? superclass.t_procs.merge(@t_procs) : superclass.t_procs rescue @t_procs.dup
        end
      end
      @sage_flow_transitions ? @sage_flow_transitions.merge!(transitions) : @sage_flow_transitions = transitions
      @t_procs ||= Hash.new if !@t_procs && block_given?

      transitions.each do |name, change|
        sage_flow_fix_hash!(change)

        define_method "can_#{name}?" do
          change.keys.flatten.map(&:to_s).include?(sage_flow_state.to_s)
        end

        if block_given?
          @t_procs["#{name}_proc".to_sym] = block
          define_method "do_#{name}" do
            if send("can_#{name}?")
              if pro = self.class.t_procs["#{name}_proc".to_sym]
                output_states = [change[sage_flow_state.to_sym]].flatten
                out_state = pro.call(sage_flow_state).to_sym
                if output_states.include?(out_state)
                  send("sage_flow_state=", out_state.to_s)
                else
                  raise "#{name} transition block returned: #{out_state}, which is not one of the output states: #{output_states.flatten.join(' ')}"
                end
              end
            end
          end
        else
          define_method "do_#{name}" do
            send("sage_flow_state=", change[sage_flow_state.to_sym].to_s) if send("can_#{name}?")
          end
        end

        define_method "do_#{name}!" do
          send("save!") if send("do_#{name}")
        end
      end

      sage_flow_states.each do |state|
        define_method "can_be_#{state}?" do
          transitions.values.map{|c| c.key(state.to_sym)}.compact!.include?(sage_flow_state.to_sym)
        end
      end
    end

    def handles_sage_flow_state_for(model)
      raise "Class #{model.class} does not inherit ActiveRecord::Base" unless model < ActiveRecord::Base
      define_method "sage_flow_state" do |id=nil|
        state = id ? model.find(id).sage_flow_state.downcase : model.find(params[:id]).sage_flow_state.downcase
        render text: state
      end

      define_method "sage_flow_state_poller" do |id=nil|
        o = id ? model.find(id) : model.find(params[:id])
        statejs = 
"$(function(){
  var #{o.class.name.downcase}_interval_#{o.id} = setInterval(function(){
    $.get('/#{o.class.name.downcase.pluralize}/#{o.id}/sage_flow_state.txt',function(state){
      if (state != '#{o.sage_flow_state}'}) {
        clearInterval(#{o.class.name.downcase}_interval_#{o.id});
        location.reload();
      }
    })
  }, 1000);
})"
        render js: statejs
        statejs
      end

      model.sage_flow_transitions.each do |name, change|
        define_method "perform_#{name}" do |id=nil|
          o = id ? model.find(id) : model.find(params[:id])
          if o.send("can_#{name}?")
            o.send("do_#{name}!") 
            redirect_to o, notice: "#{o.class} object is now #{o.sage_flow_state}"
          else
            redirect_to o, alert: "#{o.class} object of id: #{o.id} cannot perform #{name} transition from state \'#{o.sage_flow_state}\'"
          end
        end
      end
    end
  end
end
