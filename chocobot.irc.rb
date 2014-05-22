#!/usr/local/bin/ruby

require "socket"

class ChocobotIRC
    def initialize(server, port, nick, pass, channel)
        @server = server
        @port = port
        @nick = nick
        @pass = pass
        @channel = channel
    end

    def send(s)
        @irc.send "#{s}\n", 0 
    end

    def connect()
        @irc = TCPSocket.open(@server, @port)
        send "PASS #{@pass}"
        send "USER Chocobot IRC CVN :Chocobot CVN IRC Bot"
        send "NICK #{@nick}"
        send "JOIN #{@channel}"
    end

    def handle_server_input(s)
        case s.strip
            when /^PING :(.+)$/i
                send "PONG :#{$1}"
            when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s.+\s:[\001]PING (.+)[\001]$/i
                send "NOTICE #{$1} :\001PING #{$4}\001"
            when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s.+\s:[\001]VERSION[\001]$/i
                send "NOTICE #{$1} :\001VERSION Chocobot 0.32\001"
            when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s.+\s:(.*)$/i
                puts "#{$4}"
            else
        end
    end

    def main_loop()
        while true
            ready = select([@irc, $stdin], nil, nil, nil)
            next if !ready
            for s in ready[0]
                if s == $stdin then
                    return if $stdin.eof
                    s = $stdin.gets
                    send s
                elsif s == @irc then
                    return if @irc.eof
                    s = @irc.gets
                    handle_server_input(s)
                end
            end
        end
    end
end