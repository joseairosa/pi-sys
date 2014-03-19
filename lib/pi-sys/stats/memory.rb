module PiSys
  class Memory < Stats

    KEY = :memory
    VARIATIONS = [:status, :usage, :info]
    COMMAND = :get_mem

    def initialize
      @vcgencmd = Vcgencmd.new(KEY, COMMAND)
      super(KEY, VARIATIONS)
    end

    def fetch
      super

      # status
      output = fetch_status
      if output
        output.gsub!(/ kB$/, '').gsub(/\: */, ' ')
        to_hash([KEY, :status], output) do |data|
          {data[0].gsub(':','') => data[1].to_i / 1024}
        end

        STATS[KEY][:status]['MemUsed'] = STATS[KEY][:status]['MemTotal'] - STATS[KEY][:status]['MemFree'] -
          STATS[KEY][:status]['Buffers'] - STATS[KEY][:status]['Cached']
      else
        STATS[KEY][:status] = {}
      end

      # info
      output = @vcgencmd.fetch
      if output
        STATS[KEY][:info] = @vcgencmd.fetch
      else
        STATS[KEY][:info] = {}
      end

      # usage
      output = fetch_usage
      if output
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
      else
        STATS[KEY][:usage] = {}
      end
      STATS[KEY]
    end

    private

    def fetch_status
      file = File.open('/proc/meminfo', 'rb')
      output = file.read
      file.close
      output
    end

    def fetch_usage
      run_command 'ps -eo comm,rss'
    end
  end
end