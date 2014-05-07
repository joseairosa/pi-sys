require 'spec_helper'

describe PiSys::Disk do
  before do
    allow_any_instance_of(described_class).to receive(:fetch_io) {
      '''
Linux 3.10.25+ (raspberrypi01) 	06/05/14 	_armv6l_	(1 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
mmcblk0          43.60     0.72    1.71    0.50   184.39     8.07   173.83     0.07   29.51   14.01   82.22   7.56   1.67

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
mmcblk0           0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
'''
    }
    allow_any_instance_of(described_class).to receive(:fetch_usage) {
'''
Filesystem     1K-blocks     Used Available Use% Mounted on
rootfs           7254872  2710496   4152800  40% /
/dev/root        7254872  2710496   4152800  40% /
devtmpfs          240208        0    240208   0% /dev
tmpfs              49696      260     49436   1% /run
tmpfs               5120        0      5120   0% /run/lock
tmpfs              99380        0     99380   0% /run/shm
/dev/mmcblk0p7     60479    19000     41479  32% /boot
/dev/sda2      488364544 43396576 444967968   9% /mnt/TimeCapsule
/dev/sda3      487897560 55656784 432240776  12% /mnt/storage
'''
    }
  end

  subject { PiSys.disk }


  context 'when asking for io' do
    context 'with 1 device' do
      before do
        allow_any_instance_of(described_class).to receive(:fetch_io) {
          '''
Linux 3.10.25+ (raspberrypi01) 	06/05/14 	_armv6l_	(1 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
mmcblk0          43.60     0.72    1.71    0.50   184.39     8.07   173.83     0.07   29.51   14.01   82.22   7.56   1.67

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
mmcblk0           0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
'''
        }
      end
      it 'should generate data' do
        expect(subject[:io]).to be_a Array
        expect(subject[:io].count).to eq 1
        expect(subject[:io][0]['Device:']).to eq('mmcblk0')
      end
    end
    context 'with 2 devices' do
      before do
        allow_any_instance_of(described_class).to receive(:fetch_io) {
          '''
Linux 3.10.25+ (raspberrypi01) 	06/05/14 	_armv6l_	(1 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
mmcblk0          43.60     0.72    1.71    0.50   184.39     8.07   173.83     0.07   29.51   14.01   82.22   7.56   1.67
sda              43.60     0.72    1.71    0.50   184.39     8.07   173.83     0.07   29.51   14.01   82.22   7.56   1.67

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
mmcblk0           0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
'''
        }
      end
      it 'should generate data' do
        expect(subject[:io]).to be_a Array
        expect(subject[:io].count).to eq 2
        expect(subject[:io][0]['Device:']).to eq('mmcblk0')
        expect(subject[:io][1]['Device:']).to eq('sda')
      end
    end
    context 'with 3 devices' do
      before do
        allow_any_instance_of(described_class).to receive(:fetch_io) {
          '''
Linux 3.10.25+ (raspberrypi01) 	06/05/14 	_armv6l_	(1 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
mmcblk0          43.60     0.72    1.71    0.50   184.39     8.07   173.83     0.07   29.51   14.01   82.22   7.56   1.67
sda              43.60     0.72    1.71    0.50   184.39     8.07   173.83     0.07   29.51   14.01   82.22   7.56   1.67
sda1             43.60     0.72    1.71    0.50   184.39     8.07   173.83     0.07   29.51   14.01   82.22   7.56   1.67

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
mmcblk0           0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
'''
        }
      end
      it 'should generate data' do
        expect(subject[:io]).to be_a Array
        expect(subject[:io].count).to eq 3
        expect(subject[:io][0]['Device:']).to eq('mmcblk0')
        expect(subject[:io][1]['Device:']).to eq('sda')
        expect(subject[:io][2]['Device:']).to eq('sda1')
      end
    end
  end

  context 'when asking for usage' do
    it 'should generate data' do
      expect(subject[:usage]['rootfs']).to eq({used: '2710496', available: 4152800, percentage: 40, mounted_on: '/'})
    end
  end

  context 'when running the command returns an error' do
    before do
      allow_any_instance_of(described_class).to receive(:fetch_io).and_return(nil)
      allow_any_instance_of(described_class).to receive(:fetch_usage).and_return(nil)
    end

    it { expect(subject).to eq({}) }
  end
end
