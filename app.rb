require "socket"

server = TCPServer.new('localhost', 3000)
print "server @ http://localhost:3000\n"

def http_response(response)
	return "HTTP/1.1 200 OK\r\n" +
		"Content-Type: text/html\r\n" +
		"Content-Length: #{response.bytesize}\r\n" +
		"Connection: close\r\n" +
		"\r\n" +
		response
end

loop do

	socket = server.accept
	request = socket.gets.split

	print request

	if request[0] == "GET"
		case request[1]
		when "/"
			socket.print http_response File.read("pages/index.html")
		else
			socket.print http_response "You asked for #{request[1]}"
		end
	else
		socket.print "Only GET requests are supported right now"
		socket.close
	end
end