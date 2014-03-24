module PiSys
  class Clock < Vcgencmd
    KEY = :clock
    COMMAND = :measure_clock

    def initialize
      super(KEY, COMMAND)
    end

    def fetch
      STATS[KEY] = super
    end
  end
end
