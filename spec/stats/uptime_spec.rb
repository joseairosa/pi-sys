require 'spec_helper'

describe PiSys::Uptime do
  before do
    allow_any_instance_of(Kernel).to receive(:`) {
      '''
      23:34:05 up 1 day, 52 min,  1 user,  load average: 0.08, 0.09, 0.12
      '''
    }
  end

  subject { PiSys.uptime }

  it 'should respond to time' do
    expect(subject[:time]).to eq '23:34:05'
  end
  it 'should respond to up' do
    expect(subject[:up]).to eq '1 day, 52 min'
  end
  it 'should respond to users' do
    expect(subject[:users]).to eq '1'
  end
  it 'should respond to load_average' do
    expect(subject[:load_average]).to eq(one: '0.08', five: '0.09', fiftheen: '0.12')
  end
end
