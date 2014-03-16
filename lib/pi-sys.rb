$:.push("#{File.dirname(__FILE__)}/..")

require 'lib/pi-sys/stats'
require 'lib/pi-sys/stats/vcgencmd'
Dir['lib/pi-sys/stats/*.rb'].each {|file| require file }

module PiSys
  STATS = {}
  MODULES = [:cpu, :disk, :memory, :clock, :voltage, :temperature, :codec, :config, :uptime].map { |mod|
    {mod => const_get(mod.to_s.capitalize).new}
  }.reduce({}, :merge)

  class << self
    MODULES.each do |mod, _|
      define_method(mod) { MODULES[mod].fetch }
    end
  end
end
