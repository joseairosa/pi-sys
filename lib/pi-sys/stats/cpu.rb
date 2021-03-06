module PiSys
  class Cpu < Stats

    KEY = :cpu
    VARIATIONS = nil

    def initialize
      super(KEY, VARIATIONS)
    end

    def fetch
      super

      output = run_command 'pidstat -h'

      if output
        to_hash(KEY, output, 3) do |data|
          name = data[7]
          {name => {user: data[2].to_f, system: data[3].to_f, guest: data[4].to_f, total: data[5].to_f}}
        end

        Hash[STATS[KEY].sort_by{|_, v| -v[:total]}]
      else
        STATS[KEY]
      end
    end
  end
end
