#!/usr/bin/ruby

require "json"
require "open-uri"
require "socket"

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

def parse_json(userData)
    # This code turns JSON values into facts, but requires very strict JSON fields
    # Not ready for use yet
    checked_json = userData.gsub("'", '"')
    JSON.parse(checked_json).each do |array|
        key = array[0].dup
        key.insert(0, "ec2_user-data_")
        val = array[1].dup
        Facter.add(key) { setcode { val } }
    end
end

def get_user_data()
    begin
        open("http://169.254.169.254/latest/user-data") do |f|
            f.each do |userData|
                Facter.add("ec2_user_data") { setcode { userData } }
            end
        end
    rescue OpenURI::HTTPError
        Facter.add("ec2_user_data") { setcode { "None" } }
    end
end

if can_connect?("169.254.169.254",80)
    get_user_data
else
    Facter.debug "Not an EC2 host"
end
