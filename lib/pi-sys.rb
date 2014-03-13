$:.push("#{File.dirname(__FILE__)}/..")

module PiSys
  STATS = {}
  MODULES = [:cpu, :disk, :memory, :clock, :voltage, :temperature, :codec, :config, :stats, :uptime].map { |mod|
    {mod => Kernel.const_get(mod.to_s.capitalize).new}
  }.reduce({}, :merge)

  MODULES.each do |method|
    define_method(method) {
      MODULES[method]
    }
  end
end