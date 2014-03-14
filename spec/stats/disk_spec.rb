require 'spec_helper'

describe PiSys::Disk do
  before do
    allow_any_instance_of(described_class).to receive(:fetch_io) {
'''
Linux 3.10.25+ (raspberrypi01) 	14/03/14 	_armv6l_	(1 CPU)

#      Time       PID   kB_rd/s   kB_wr/s kB_ccwr/s  Command
 1394831695      1831      0.76      0.10      0.00  deluged
 1394831695      2708      0.08      0.00      0.00  bash
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
    specify 'should generate data' do
      expect(subject[:io]['deluged']).to eq({read: '0.76', write: '0.10'})
    end
  end

  context 'when asking for usage' do
    specify 'should generate data' do
      expect(subject[:usage]['rootfs']).to eq({used: '2710496', available: 4152800, percentage: 40, mounted_on: '/'})
    end
  end
end
