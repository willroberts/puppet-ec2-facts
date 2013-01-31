#!/usr/bin/ruby

require 'open-uri'
require 'timeout'
require 'socket'

def can_connect?(addr, port, timeout=2)
  t = Socket.new(Socket::Constants::AF_INET, Socket::Constants::SOCK_STREAM, 0)
  saddr = Socket.pack_sockaddr_in(port, addr)
  connected = false
  begin
    t.connect_nonblock(saddr)
  rescue Errno::EINPROGRESS
    r,w,e = IO::select(nil,[t],nil,timeout)
    if !w.nil?
      connected = true
    else
      begin
        t.connect_nonblock(saddr)
      rescue Errno::EISCONN
        t.close
        connected = true
      rescue SystemCallError
      end
    end
  rescue SystemCallError
  end
  connected
end

def find_ebs_volumes()
  symbol = "ec2_ebs_present"
  value = "False"
  open("http://169.254.169.254/latest/meta-data/block-device-mapping/") { |f|
    f.each_line { |line|
      if line.include? 'ebs'
        value = "True"
      end
    }
  }
  Facter.add(symbol) { setcode { value } }
end

if can_connect?("169.254.169.254",80)
  find_ebs_volumes
else
  Facter.debug "Not an EC2 host"
end
