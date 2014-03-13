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

module PiSys
  STATS = {}
    {mod => Kernel.const_get(mod.to_s.capitalize).new}
  MODULES = [:cpu, :disk, :memory, :clock, :voltage, :temperature, :codec, :config, :uptime].map { |mod|
  }.reduce({}, :merge)

  MODULES.each do |method|
    define_method(method) {
      MODULES[method]
    }
  end
end