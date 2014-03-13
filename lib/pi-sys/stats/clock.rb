module PiSys
  class Clock < Vcgencmd
    KEY = :clock
    COMMAND = :measure_clock

    def initialize
      super
    end

    def fetch
      super
    end
  end
end