module PiSys
  class Disk < Stats

    KEY = :disk
    VARIATIONS = [:io, :usage]

    def initialize
      super
    end

    def fetch
      super

      output = `pidstat -h`
      to_hash([KEY, :io], output, 3) do |data|
        name = data[5]
        {name => {read: data[2], write: data[3]}}
      end

      output = `df`
      to_hash([KEY, :usage], output, 1) do |data|
        name = data[0]
        {name => {used: data[2], available: data[3].to_i, percentage: data[4].to_i, mounted_on: data[5]}}
      end

      STATS[KEY][:usage] = Hash[STATS[KEY][:usage].sort_by { |_, v| -v[:percentage] }]
      STATS[KEY]
    end
  end
end