module PiSys
  class Stats
    def initialize(key, variations)
      @key, @variations = key, variations
      STATS[@key] = {}

      if @variations
        @variations.each { |method|
          self.class.send(:define_method, method, Proc.new{ STATS[@key][method.to_sym ] })
        }
      end
    end

    def to_hash(statistic, output, start_index=0)
      output.strip.split("\n")[start_index..-1].each do |data_line|
        data = data_line.split(' ')
        unless data.empty?
          if statistic.kind_of? Array
            STATS[statistic[0]] ||= {}
            STATS[statistic[0]][statistic[1]] ||= {}
            STATS[statistic[0]][statistic[1]].merge!(yield(data)) if block_given?
          else
            STATS[statistic] ||= {}
            STATS[statistic].merge!(yield(data)) if block_given?
          end
        end
      end
      STATS[statistic]
    end

    private

    def reset
      STATS[@key] = {}
    end

    def fetch
      reset
    end
  end
end
