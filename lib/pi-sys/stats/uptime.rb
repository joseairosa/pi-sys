module PiSys
  class Uptime < Stats

    KEY = :uptime
    VARIATIONS = nil

    def initialize
      super(KEY, VARIATIONS)
    end

    def fetch
      super

      output = run_command 'uptime'

      to_hash(KEY, output) do |data|
        index_of_reference = data.index('user,') || data.index('users,')
        {
          time: data[0],
          up: data[2..index_of_reference-2].join(' ').gsub(/(,$)/i,''),
          users: data[index_of_reference-1],
          load_average: {
            one: data[data.length-3].gsub(',',''),
            five: data[data.length-2].gsub(',',''),
            fiftheen: data[data.length-1].gsub(',','')
          }
        }
      end
    end
  end
end