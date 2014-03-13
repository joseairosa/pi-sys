module PiSys
  class Memory < Stats

    KEY = :memory
    VARIATIONS = [:status, :usage, :info]
    COMMAND = :get_mem

    def initialize
      @vcgencmd = Vcgencmd.new
      super
    end

    def fetch
      super

      # status
      file = File.open('/proc/meminfo', 'rb')
      output = file.read
      file.close
      output.gsub!(/ kB$/, '').gsub(/\: */, ' ')
      to_hash([KEY, :status], output) do |data|
        {data[0].to_sym => data[1].to_i / 1024}
      end
      STATS[KEY][:status][:MemUsed] = STATS[KEY][:status][:MemTotal] - STATS[KEY][:status][:MemFree] -
        STATS[KEY][:status][:Buffers] - STATS[KEY][:status][:Cached]

      # info
      STATS[KEY][:info] = @vcgencmd.fetch

      # usage
      output = `ps -eo comm,rss`
      to_hash([KEY, :usage], output, 1) do |data|
        name = data[0]
        value = data[1].to_i / 1024
        if STATS[KEY][:usage][name]
          STATS[KEY][:usage][name] += value
          {}
        else
          {name => value}
        end
      end

      STATS[KEY][:usage] = Hash[STATS[KEY][:usage].sort_by { |_, v| -v }]
      STATS[KEY]
    end
  end
end