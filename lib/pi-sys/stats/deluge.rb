module PiSys
  class Deluge < Stats

    KEY = :deluge
    VARIATIONS = nil

    def initialize
      super(KEY, VARIATIONS)
    end

    def fetch
      STATS[KEY] = []

      output = run_command 'deluge-console info'

      if output
        hash = {}
        output.strip.split("\n")[0..-1].each do |data_line|
          if data_line.empty?
            STATS[KEY] << hash
            hash = {}
          else
            data = data_line.split(':')
            hash[data[0].downcase] = data[1..-1].join.strip
          end
        end
        STATS[KEY] << hash
      end
      STATS[KEY]
    end
  end
end
