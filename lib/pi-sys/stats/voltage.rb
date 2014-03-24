module PiSys
  class Voltage < Vcgencmd
    KEY = :voltage
    COMMAND = :measure_volts

    def initialize
      super(KEY, COMMAND)
    end

    def fetch
      STATS[KEY] = super
    end
  end
end
