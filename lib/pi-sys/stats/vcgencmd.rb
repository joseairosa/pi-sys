module PiSys
  class Vcgencmd < Stats

    COMMANDS = {
        measure_clock: %w(arm core h264 isp v3d uart pwm emmc pixel vec hdmi dpi),
        measure_volts: %w(core sdram_c sdram_i sdram_p),
        measure_temp: nil,
        codec_enabled: %w(H264 MPG2 WVC1 MPG4 MJPG WMV9),
        get_config: %w(int),
        get_mem: %w(arm gpu)
    }

    def initialize(key, command)
      @key, @command = key, command
      super(key, nil)
    end

    private

    def fetch(command=@command)
      if COMMANDS.has_key? command
        if COMMANDS[command]
          hash ||= {}
          COMMANDS[command].each do |option|
            output = `/opt/vc/bin/vcgencmd #{command} #{option}`
            hash[option] = Hash[output.split("\n").map {|entry| entry.split('=')}]
          end
        else
          output = `/opt/vc/bin/vcgencmd #{command}`
          Hash[output.split("\n").map {|entry| entry.split('=')}]
        end
      end
    end
  end
end