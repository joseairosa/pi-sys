require 'spec_helper'

describe PiSys::Temperature do
  before do
    allow_any_instance_of(PiSys::Vcgencmd).to receive(:run_command).and_return(
"""
temp=54.1'C
""")
  end

  subject { PiSys.temperature }

  specify { expect(subject['temp']).to eq "54.1'C" }
end