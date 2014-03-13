module PiSys
  class Temperature < Vcgencmd
    KEY = :temperature
    COMMAND = :measure_temp

    def initialize
      super
    end

    def fetch
      super
    end
  end
end