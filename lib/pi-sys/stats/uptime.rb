module PiSys
  class Uptime < Stats

    KEY = :uptime
    VARIATIONS = nil

    def initialize
      super
    end

    def fetch
      super

      output = `uptime`

      to_hash(KEY, output, 3) do |data|
        {time: data[0], up: data[2], users: data[3], load_average: {one: data[7], five: data[8], fiftheen: data[9]}}
      end
    end
  end
end