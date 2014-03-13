module PiSys
  class Config < Vcgencmd
    KEY = :config
    COMMAND = :get_config

    def initialize
      super(KEY, COMMAND)
    end

    def fetch
      super
    end
  end
end