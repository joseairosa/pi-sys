require 'usagewatch'

module PiSys
  class Bandwidth < Stats

    KEY = :bandwidth
    VARIATIONS = nil

    def initialize
      super(KEY, VARIATIONS)
    end

    def fetch
      super

      # We want this in bytes
      STATS[KEY] = {rx: Usagewatch.uw_bandrx / 8, tx: Usagewatch.uw_bandtx / 8}
    end
  end
end
