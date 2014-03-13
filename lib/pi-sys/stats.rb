module PiSys
  class Stats
    def initialize
      STATS[KEY] = self
    end

    def to_hash(stat, output, start_index=0)
      output.split("\n")[start_index..-1].each do |data_line|
        data = data_line.split(' ')
        if stat.kind_of? Array
          STATS[stat[0]][stat[1]].merge!(yield(data)) if block_given?
        else
          STATS[stat].merge!(yield(data)) if block_given?
        end
      end
      STATS[stat]
    end

    VARIATIONS.each { |method| define_method(method.to_sym) {STATS[key][method.to_sym ]} } if VARIATIONS

    private

    def reset
      if VARIATIONS
        VARIATIONS.each do |section|
          STATS[KEY][section] = {}
        end
      else
        STATS[KEY] = {}
      end
    end

    def fetch
      reset
    end
  end
end