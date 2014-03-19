require 'spec_helper'

describe PiSys::Codec do
  before do
    allow_any_instance_of(PiSys::Vcgencmd).to receive(:run_command).and_return(
'''
frequency(45)=700074000
'''
)
  end

  subject { PiSys.codec }

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