require 'spec_helper'

describe PiSys::Memory do
  before do
    allow_any_instance_of(PiSys::Vcgencmd).to receive(:fetch).and_return({'arm' => '469M', 'gpu' => '16M'})
    allow_any_instance_of(described_class).to receive(:fetch_status) {
'''
MemTotal:         496948 kB
MemFree:          354480 kB
Buffers:           17524 kB
Cached:            52336 kB
SwapCached:            0 kB
Active:            76480 kB
Inactive:          49336 kB
Active(anon):      55988 kB
Inactive(anon):      228 kB
Active(file):      20492 kB
Inactive(file):    49108 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:        102396 kB
SwapFree:         102396 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:         55968 kB
Mapped:            14936 kB
Shmem:               264 kB
Slab:               8920 kB
SReclaimable:       5024 kB
SUnreclaim:         3896 kB
KernelStack:         600 kB
PageTables:          812 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:      350868 kB
Committed_AS:     125776 kB
VmallocTotal:     516096 kB
VmallocUsed:        1580 kB
VmallocChunk:     299736 kB
'''
    }
    allow_any_instance_of(described_class).to receive(:fetch_usage) {
'''
COMMAND           RSS
init              712
kthreadd            0
ksoftirqd/0         0
kworker/0:0H        0
kworker/u2:0        0
rcu_preempt         0
rcu_bh              0
rcu_sched           0
khelper             0
kdevtmpfs           0
netns               0
kworker/0:1         0
writeback           0
bioset              0
kblockd             0
khubd               0
rpciod              0
khungtaskd          0
kswapd0             0
fsnotify_mark       0
nfsiod              0
crypto              0
kthrotld            0
VCHIQ-0             0
VCHIQr-0            0
VCHIQs-0            0
iscsi_eh            0
dwc_otg             0
DWC Notificatio     0
deferwq             0
kworker/u2:2        0
mmcqd/0             0
scsi_eh_0           0
usb-storage         0
jbd2/mmcblk0p8-     0
ext4-dio-unwrit     0
kworker/0:2         0
udevd            1280
udevd            1024
udevd             972
ifplugd           504
ifplugd           504
deluged         20972
dhclient         1988
rsyslogd         1584
cron              948
dbus-daemon       880
ntpd             1728
sshd             1068
cnid_metad        956
afpd             2268
avahi-daemon     1692
avahi-daemon      536
thd               640
ruby1.9.1       36424
getty             804
getty             804
getty             804
getty             804
getty             804
getty             804
getty             736
sshd             2976
sshd             1496
bash             3540
VCHIQka-0           0
ps                936
'''
    }
  end

  subject { PiSys.memory }

  it 'should build the correct variations' do
    expect(subject[:status]).to be_a Hash
    expect(subject[:usage]).to be_a Hash
    expect(subject[:info]).to be_a Hash
  end

  context 'when asking for status' do
    it 'should generate MemUsed' do
      expect(subject[:status]['MemUsed']).to eq 71
    end
  end

  context 'when asking for usage' do
    it 'should be sorted by highest memory usage' do
      last = nil
      subject[:usage].each do |_, usage|
        last ||= usage
        expect(usage).to be <= last
        last = usage
      end
    end
  end
end
