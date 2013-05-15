ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'
require File.expand_path(File.dirname(__FILE__) + '/../config/environment')

server = TCPServer.new 61234
server.setsockopt Socket::SOL_SOCKET, Socket::SO_REUSEADDR, true

loop do
  Thread.start(server.accept) do |client|
    state = :connected
    client.puts "220 <domain> Service ready"
    
    until client.eof?
      
      case client.gets.chomp

      when /^(HELO|EHLO) (.*)$/i
        state = :session
        client.puts "250 OK"

      when /^MAIL FROM:<(.*)>$/i
        if state == :session
          mail = IncomingMail.new
          mail.reverse_path = $1
          state = :transaction_1
          client.puts "250 OK"
        else
          client.puts "503 Bad sequence of commands"
        end

      when /^RCPT TO:<(.*)>$/i
        if state == :transaction_1
          mail.forward_path = $1
          state = :transaction_2
          client.puts "250 OK"
        elsif state == :transaction_2
          mail.forward_path << $1
          client.puts "250 OK"
        else
          client.puts "503 Bad sequence of commands"
        end
      
      when /^DATA$/i
        if state == :transaction_2
          client.puts "354 Start mail input; end with <CRLF>.<CRLF>"
          
          until client.eof?
            dataline = client.gets
            
            if dataline =~ /^\.\r\n$/
              mail.save
              state = :session
              client.puts "250 OK"
    
              ### Salida STDOUT ###
              puts "Correo recibido!"
              puts "De: " + mail.reverse_path
              puts "Para: " + mail.forward_path
              puts "----"

              break
            end

            mail.data << dataline
          end

        else
          client.puts "503 Bad sequence of commands"
        end

      when /^RSET$/i
        if state != :connected then state = :session end
        client.puts "250 OK"

      when /^NOOP$/i
        client.puts "250 OK"

      when /^QUIT$/i
        client.puts "221 <domain> Service closing transmission channel"
        break

      when /^VRFY$/i
        client.puts "502 Command not implemented"

      else
        client.puts "500 Syntax error, command unrecognized"

      end
    end
    
    client.close
  end
end
