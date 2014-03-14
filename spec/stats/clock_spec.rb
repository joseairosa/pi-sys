require 'spec_helper'

describe PiSys::Clock do
  before do
    allow_any_instance_of(PiSys::Vcgencmd).to receive(:run_command).and_return(
'''
frequency(45)=700074000
'''
)
  end

  subject { PiSys.clock }

  specify {
    described_class::COMMANDS[described_class::COMMAND].each do |option|
      expect(subject[option]).to be_a Hash
    end
  }
end