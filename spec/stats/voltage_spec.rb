require 'spec_helper'

describe PiSys::Voltage do
  before do
    allow_any_instance_of(PiSys::Vcgencmd).to receive(:run_command).and_return('volt=1.20V')
  end

  subject { PiSys.voltage }

  specify { expect(subject['core']['volt']).to eq '1.20V' }
  specify { expect(subject['sdram_c']['volt']).to eq '1.20V' }
  specify { expect(subject['sdram_i']['volt']).to eq '1.20V' }
  specify { expect(subject['sdram_p']['volt']).to eq '1.20V' }
end