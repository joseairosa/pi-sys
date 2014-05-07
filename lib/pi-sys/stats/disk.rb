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
      if output
        clean_data = output.split("\n").reject { |e| e.empty? }.map { |e| e.split(' ') }
        relevant_data = clean_data[4..-1]
        STATS[KEY][:io] = []
        relevant_data[1..-1].each do |data_values|
          new_data = {}
          relevant_data[0].each_with_index do |key, i|
            new_data[key] = data_values[i]
          end
          STATS[KEY][:io] << new_data unless new_data.empty?
        end
      end

      output = fetch_usage

      if output
        to_hash([KEY, :usage], output, 1) do |data|
          name = data[0]
          {name => {used: data[2], available: data[3].to_i, percentage: data[4].to_i, mounted_on: data[5]}}
        end

        STATS[KEY][:usage] = Hash[STATS[KEY][:usage].sort_by { |_, v| -v[:percentage] }]
      end

      STATS[KEY]
    end

    private

    def fetch_io
      run_command('iostat -d -x 1 2')
    end

    def fetch_usage
      run_command('df')
    end
  end
end
