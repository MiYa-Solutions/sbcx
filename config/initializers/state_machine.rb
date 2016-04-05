unless defined? StateMachine::Machine::Constants::RGV_VERSION
  warn "StateMachine::Machine::Constants overriden in #{__FILE__}"

  class StateMachine::Machine::Constants
    RGV_VERSION = /^[ ]*ruby-graphviz \(([0-9.]+)\)/.match(`cat #{Rails.root.join 'Gemfile.lock'}`)[1]
  end
end