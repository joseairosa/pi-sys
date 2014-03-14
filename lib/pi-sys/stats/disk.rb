module PiSys
  class Disk < Stats

    KEY = :disk
    VARIATIONS = [:io, :usage]

    def initialize
      super(KEY, VARIATIONS)
    end

    def fetch
      super

      output = fetch_io
      to_hash([KEY, :io], output, 3) do |data|
        name = data[5]
        {name => {read: data[2], write: data[3]}}
      end

      output = fetch_usage
      to_hash([KEY, :usage], output, 1) do |data|
        name = data[0]
        {name => {used: data[2], available: data[3].to_i, percentage: data[4].to_i, mounted_on: data[5]}}
      end

      STATS[KEY][:usage] = Hash[STATS[KEY][:usage].sort_by { |_, v| -v[:percentage] }]
      STATS[KEY]
    end

    private

    def fetch_io
      `pidstat -h`
    end

    def fetch_usage
      `df`
    end
  end
end