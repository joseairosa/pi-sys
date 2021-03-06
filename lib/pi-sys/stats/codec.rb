module PiSys
  class Codec < Vcgencmd
    KEY = :codec
    COMMAND = :codec_enabled

    def initialize
      super(KEY, COMMAND)
    end

    def fetch
      STATS[KEY] = super
    end
  end
end
