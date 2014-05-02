require 'spec_helper'

describe PiSys::Deluge do
  before do
    allow_any_instance_of(Kernel).to receive(:`) {
      '''

Name: The.Blacklist.S01E16.720p.HDTV.X264-DIMENSION
ID: 142f630f92aaf58c1ec9e060e5fc63ef6c362102
State: Paused
Size: 846.5 MiB/846.5 MiB Ratio: 0.000
Seed time: 0 days 00:00:06 Active: 0 days 00:06:20
Tracker status: torrentleech.org: Announce OK

Name: The.Hobbit.The.Desolation.of.Smaug.2013.720p.BluRay.x264-SPARKS
ID: 84c29468d0e6ae61997cc2c4dd5adf09b2a69b8a
State: Paused
Size: 6.6 GiB/6.6 GiB Ratio: 0.000
Seed time: 0 days 00:00:03 Active: 0 days 00:43:24
Tracker status: torrentleech.org: Announce OK
      '''
    }
  end

  xit { PiSys.deluge }

  xit { expect(subject).to be_a Array }
  xit { expect(subject.count).to eq 2 }

  context 'when running the command returns an error' do
    before do
      allow_any_instance_of(Kernel).to receive(:`).and_return(nil)
    end

    xit { expect(subject).to eq([]) }
  end

  context 'when command not found' do
    before do
      allow_any_instance_of(Kernel).to receive(:`).and_raise(Errno::ENOENT, 'No such file or directory - ada')
    end

    xit { should be_empty }
  end
end
