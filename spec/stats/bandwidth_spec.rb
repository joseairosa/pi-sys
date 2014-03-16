require 'spec_helper'

describe PiSys::Bandwidth do
  before do
    allow(Usagewatch).to receive(:uw_bandrx).and_return(25.835)
    allow(Usagewatch).to receive(:uw_bandtx).and_return(0.306)
  end

  subject { PiSys.bandwidth }

  specify { expect(subject).to be_a Hash }

  specify 'should generate data' do
    expect(subject[:rx]).to eq 3.229375
    expect(subject[:tx]).to eq 0.03825
  end
end
