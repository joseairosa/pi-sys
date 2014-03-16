$:.push("#{File.dirname(__FILE__)}/..")

require 'lib/pi-sys/stats'
require 'lib/pi-sys/stats/vcgencmd'
require 'lib/pi-sys/stats/cpu'
require 'lib/pi-sys/stats/memory'
require 'lib/pi-sys/stats/clock'
require 'lib/pi-sys/stats/codec'
require 'lib/pi-sys/stats/config'
require 'lib/pi-sys/stats/disk'
require 'lib/pi-sys/stats/temperature'
require 'lib/pi-sys/stats/uptime'
require 'lib/pi-sys/stats/voltage'
require 'lib/pi-sys/stats/bandwidth'

module PiSys
  STATS = {}
  MODULES = [:cpu, :disk, :memory, :clock, :voltage, :temperature, :codec, :config, :uptime, :bandwidth].map { |mod|
    {mod => const_get(mod.to_s.capitalize).new}
  }.reduce({}, :merge)

  class << self
    MODULES.each do |mod, _|
      define_method(mod) { MODULES[mod].fetch }
    end
  end

  def self.fetch
    MODULES.values.map(&:fetch)
    STATS
  end
end
