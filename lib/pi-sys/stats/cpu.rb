module PiSys
  class Cpu < Stats

    KEY = :cpu
    VARIATIONS = nil

    def initialize
      super
    end

    def fetch
      super

      output = `pidstat -h`

      to_hash(KEY, output, 3) do |data|
        name = data[7]
        {name => {user: data[2].to_f, system: data[3].to_f, guest: data[4].to_f, percentage: data[5].to_f}}
      end

      Hash[STATS[KEY].sort_by{|_, v| -v[:percentage]}]
    end
  end
end