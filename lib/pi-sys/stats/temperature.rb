module PiSys
  class Temperature < Vcgencmd
    KEY = :temperature
    COMMAND = :measure_temp

    def initialize
      super(KEY, COMMAND)
    end

    def fetch
      STATS[KEY] = super
      STATS[KEY]['temp'].gsub!("'C", '') if STATS[KEY]['temp']
      STATS[KEY]
    end
  end
end
