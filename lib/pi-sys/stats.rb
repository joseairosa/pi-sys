module PiSys
  class Stats
    def initialize(key, variations)
      @key, @variations = key, variations
      STATS[@key] = self

      if @variations
        @variations.each { |method|
          self.class.send(:define_method, method, Proc.new{ STATS[@key][method.to_sym ] })
        }
      end
    end

    def to_hash(stat, output, start_index=0)
      output.strip.split("\n")[start_index..-1].each do |data_line|
        data = data_line.split(' ')
        unless data.empty?
          if stat.kind_of? Array
            STATS[stat[0]][stat[1]].merge!(yield(data)) if block_given?
          else
            STATS[stat].merge!(yield(data)) if block_given?
          end
        end
      end
      STATS[stat]
    end

    private

    def reset
      if @variations
        @variations.each do |section|
          STATS[@key][section] = {}
        end
      else
        STATS[@key] = {}
      end
    end

    def fetch
      reset
    end
  end
end
