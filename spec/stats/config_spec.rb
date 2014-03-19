require 'spec_helper'

describe PiSys::Config do
  before do
    allow_any_instance_of(PiSys::Vcgencmd).to receive(:run_command).and_return(
'''
hdmi_force_hotplug=1
overscan_left=24
overscan_right=24
overscan_top=16
overscan_bottom=16
program_serial_random=1
config_hdmi_boost=4
emmc_pll_core=1
disable_splash=1
temp_limit=85
force_pwm_open=1
pause_burst_frames=1
second_boot=1
avoid_fix_ts=1
'''
)
  end

  subject { PiSys.config }

  specify {
    described_class::COMMANDS[described_class::COMMAND].each do |option|
      expect(subject[option]).to be_a Hash
    end
  }

  context 'when running the command returns an error' do
    before do
      allow_any_instance_of(PiSys::Vcgencmd).to receive(:run_command).and_return(nil)
    end

    specify { expect(subject).to eq({}) }
  end
end