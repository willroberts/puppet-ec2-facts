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
    # This code turns JSON values into facts, but strictly requires valid JSON!
    JSON.parse(userData.dup).each do |array|
        key = array[0].dup
        key.insert(0, "ec2_user-data_")
        val = array[1].dup
        Facter.add(key) { setcode { val } }
    end
end

def get_user_data()
    begin
        # query ec2 for user-data
        userData = open("http://169.254.169.254/latest/user-data").read()

        # attempt to parse json
        begin
            parse_json userData

        # return the full string if that fails
        rescue
            Facter.add("ec2_user-data_string") { setcode { userData } }
        end

    rescue OpenURI::HTTPError
        Facter.debug "No user-data associated with this host"
    end
end

if can_connect?("169.254.169.254",80)
    get_user_data
else
    Facter.debug "Not an EC2 host"
end
