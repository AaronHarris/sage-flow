# Defines the SageFlow::Transition class.

module SageFlow
  class Transition
    attr_accessor :initial_states
    attr_accessor :final_states
    attr_accessor :proc
    attr_reader :name

    def initialize(tname, input_states, output_states, proc=nil)
      @name = tname
      @initial_states = input_states
      @final_states = output_states
      @proc = proc
    end
  end
end
