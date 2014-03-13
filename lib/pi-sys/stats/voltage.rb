module PiSys
  class Voltage < Vcgencmd
    KEY = :voltage
    COMMAND = :measure_volts

    def initialize
      super
    end

    def fetch
      super
    end
  end
end