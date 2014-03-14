require 'spec_helper'

describe PiSys::Cpu do
  before do
    allow_any_instance_of(Kernel).to receive(:`) {
      '''
      Linux 3.10.25+ (raspberrypi01) 	13/03/14 	_armv6l_	(1 CPU)

      #      Time       PID    %usr %system  %guest    %CPU   CPU  Command
       1394742330         1    0.00    0.01    0.00    0.01     0  init
       1394742330         3    0.00    0.10    0.00    0.10     0  ksoftirqd/0
       1394742330         7    0.00    0.04    0.00    0.04     0  rcu_preempt
       1394742330        13    0.00    0.01    0.00    0.01     0  kworker/0:1
       1394742330        17    0.00    0.00    0.00    0.00     0  khubd
       1394742330        19    0.00    0.00    0.00    0.00     0  khungtaskd
       1394742330        20    0.00    0.09    0.00    0.09     0  kswapd0
       1394742330        30    0.00    0.00    0.00    0.00     0  VCHIQ-0
       1394742330        39    0.00    0.15    0.00    0.15     0  mmcqd/0
       1394742330        40    0.00    0.00    0.00    0.00     0  jbd2/mmcblk0p8-
       1394742330       114    0.00    0.11    0.00    0.11     0  usb-storage
       1394742330       159    0.00    0.00    0.00    0.00     0  udevd
       1394742330       297    0.00    0.00    0.00    0.00     0  udevd
       1394742330      1599    0.00    0.05    0.00    0.05     0  ifplugd
       1394742330      1631    0.00    0.02    0.00    0.02     0  ifplugd
       1394742330      1832    5.26    1.17    0.00    6.43     0  deluged
       1394742330      1895    0.00    0.00    0.00    0.00     0  dhclient
       1394742330      1934    0.01    0.00    0.00    0.01     0  rsyslogd
       1394742330      2002    0.00    0.00    0.00    0.00     0  cron
       1394742330      2032    0.00    0.00    0.00    0.00     0  dbus-daemon
       1394742330      2122    0.01    0.01    0.00    0.02     0  ntpd
       1394742330      2158    0.00    0.00    0.00    0.00     0  sshd
       1394742330      2260    0.00    0.00    0.00    0.00     0  cnid_metad
       1394742330      2266    0.02    0.00    0.00    0.02     0  afpd
       1394742330      2278    0.00    0.00    0.00    0.01     0  avahi-daemon
       1394742330      2424    0.00    0.00    0.00    0.00     0  thd
       1394742330      2429    0.18    0.09    0.00    0.28     0  ruby1.9.1
       1394742330      2448    0.00    0.00    0.00    0.00     0  getty
       1394742330      2449    0.00    0.00    0.00    0.00     0  getty
       1394742330      2450    0.00    0.00    0.00    0.00     0  getty
       1394742330      2451    0.00    0.00    0.00    0.00     0  getty
       1394742330      2452    0.00    0.00    0.00    0.00     0  getty
       1394742330      2453    0.00    0.00    0.00    0.00     0  getty
       1394742330      2454    0.00    0.00    0.00    0.00     0  getty
       1394742330      5420    0.00    0.00    0.00    0.00     0  kworker/u2:1
       1394742330      5421    0.00    0.00    0.00    0.00     0  kworker/0:0
       1394742330      7876    0.00    0.00    0.00    0.00     0  kworker/u2:2
       1394742330      8643    0.00    0.00    0.00    0.00     0  sshd
       1394742330      8647    0.00    0.00    0.00    0.00     0  sshd
       1394742330      8648    0.00    0.00    0.00    0.00     0  bash
       1394742330      8753    0.00    0.00    0.00    0.00     0  pidstat
      '''
    }
  end

  subject { PiSys.cpu }

  specify { expect(subject).to be_a Hash }
  specify 'should parse correctly' do
    subject.each do |process, usage|
      expect(process).to be_a String
      expect(usage).to be_a Hash
    end
  end

  specify('should respond to user') { expect(subject['deluged'][:user]).to eq 5.26 }
  specify('should respond to system') { expect(subject['deluged'][:system]).to eq 1.17 }
  specify('should respond to guest') { expect(subject['deluged'][:guest]).to eq 0.00 }
  specify('should respond to percentage') { expect(subject['deluged'][:total]).to eq 6.43 }

  specify 'should be sorted by highest cpu usage' do
    last = nil
    subject.each do |_, usage|
      last ||= usage[:total]
      expect(usage[:total]).to be <= last
      last = usage[:total]
    end
  end
end
